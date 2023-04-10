# Creating decoy user for ASREPRoast attack

Import-Module ActiveDirectory

# Check if decoy user already exists
try {
    $user = Get-ADUser -Identity j.anderson
    $UserExists = $true
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
    $UserExists = $false
}

if ($UserExists) {
    Write-Host "ASSREPRoast decoy was already deployed."
    exit
}

# Generate random password
Function Get-RandomAlphanumericString {
	
	[CmdletBinding()]
	Param (
        [int] $length = 32
	)

	Begin{
	}

	Process{
        Write-Output ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count $length  | % {[char]$_}) )
	}	
}

$password_aux= Get-RandomAlphanumericString | Tee-Object -variable teeTime
$password = ConvertTo-SecureString -String $password_aux -AsPlainText -Force

$user = @{
    Name = "John Anderson"
    GivenName = "John"
    Surname = "Anderson"
    SamAccountName = "j.anderson"
    ChangePasswordAtLogon = 0 
    CannotChangePassword = 1 
    PasswordNeverExpires = 1 
    AccountPassword = $password
    Enabled = 1
    }
New-ADUser @user

Set-ADAccountControl -Identity j.anderson -DoesNotRequirePreAuth $True

Add-ADGroupMember -Identity "Domain Admins" -Members "j.anderson"  # to execute an initial login

# To update the value of LastLogon to make the decoy user more realistic
$username = 'COMPANYDOMAIN\j.anderson'
$credential = New-Object System.Management.Automation.PSCredential $username, $password
$ActivateLastLogon = Start-Process powershell.exe -Credential $credential -PassThru -ArgumentList '-WindowStyle Hidden' -WorkingDirectory 'C:\Windows\System32'
Stop-Process $ActivateLastLogon -Force

Remove-ADGroupMember -Identity "Domain Admins" -Members j.anderson 
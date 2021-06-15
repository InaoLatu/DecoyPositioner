# Creating decoy user for ASREPRoast attack

Import-Module ActiveDirectory
$password = "Password1" | ConvertTo-SecureString -AsPlainText -Force

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

$username = 'COMPANYDOMAIN\j.anderson'
$credential = New-Object System.Management.Automation.PSCredential $username, $password
$ActivateLastLogon = Start-Process powershell.exe -Credential $credential -PassThru -ArgumentList '-WindowStyle Hidden'
Stop-Process $ActivateLastLogon -Force
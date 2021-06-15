# Creating decoy user for Kerberoasting attack

Import-Module ActiveDirectory
$password = "Password1" | ConvertTo-SecureString -AsPlainText -Force

try {
    $user = Get-ADUser -Identity j.kelly
    $UserExists = $true
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
    $UserExists = $false
}

if ($UserExists) {
    Write-Host "Kerberoasting decoy was already deployed."
    exit
}

$user = @{
    Name = "John Kelly"
    GivenName = "John"
    Surname = "Kelly"
    SamAccountName = "j.kelly"
    ChangePasswordAtLogon = 0 
    CannotChangePassword = 1 
    PasswordNeverExpires = 1 
    AccountPassword = $password
    Enabled = 1
    OtherAttributes = @{'adminCount'=1; 'servicePrincipalName'="MSSQLSvc/db3.companydomain.local"}
    }
New-ADUser @user

Add-ADGroupMember -Identity "Domain Admins" -Members "j.kelly"

# To update the value of LastLogon 
$username = 'COMPANYDOMAIN\j.kelly'
$credential = New-Object System.Management.Automation.PSCredential $username, $password
$ActivateLastLogon = Start-Process powershell.exe -Credential $credential -PassThru -ArgumentList '-WindowStyle Hidden'
Stop-Process $ActivateLastLogon -Force
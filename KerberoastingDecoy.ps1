Import-Module ActiveDirectory

$password = "Password1" | ConvertTo-SecureString -AsPlainText -Force

try {
    $user = Get-ADUser -Identity j.robinson3
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
    Name = "John Kerberoasting"
    GivenName = "John"
    Surname = "Kerberoasting"
    SamAccountName = "j.kerberoasting"
    ChangePasswordAtLogon = 0 
    CannotChangePassword = 1 
    PasswordNeverExpires = 1 
    AccountPassword = $password
    Enabled = 1
    OtherAttributes = @{'adminCount'=1; 'servicePrincipalName'="MSSQLSvc/db3.companydomain.local"}
    }
New-ADUser @user

Add-ADGroupMember -Identity "Domain Admins" -Members "j.robinson3"
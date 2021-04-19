Import-Module ActiveDirectory
#New-ADUser -Name "Jack Robinson" -GivenName "Jack" -Surname "Robinson" -SamAccountName "J.Robinson" -OtherAttributes @{'adminCount'=1} -AccountPassword $password -Enabled $true
# $username = "j.robinson"
$password = "Password1" | ConvertTo-SecureString -AsPlainText -Force
# $last_logon = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffffff"

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
    Name = "Jack R3"
    GivenName = "Jack"
    Surname = "Robinson"
    SamAccountName = "j.robinson3"
    ChangePasswordAtLogon = 0 
    CannotChangePassword = 1 
    PasswordNeverExpires = 1 
    AccountPassword = $password
    Enabled = 1
    OtherAttributes = @{'adminCount'=1; 'servicePrincipalName'="MSSQLSvc/db3.marvel.local"}
    #Path = "CN=Domain Admins,CN=Users,DC=marvel,DC=local"
    #Description = "Student"
    #UserPrincipalName = "$username@domain.local"
    #EmailAddress = "$email" 
    #HomeDrive = H: 
    #HomeDirectory = "\\$server\Students\$yog\$username" 
    #ScriptPath = "$script" 
    
    #Path = "OU=$yog,OU=$group,OU=STUDENTS,DC=domain,DC=local"
    }
New-ADUser @user

Add-ADGroupMember -Identity "Domain Admins" -Members "j.robinson3"

# # Validate credentials to update the LastLogon attribute 
# $CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
# $domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$username,$password)
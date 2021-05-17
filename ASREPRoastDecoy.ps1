Import-Module ActiveDirectory
$password = "Password1" | ConvertTo-SecureString -AsPlainText -Force

try {
    $user = Get-ADUser -Identity j.asreproast
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
    Name = "John ASSREPRoast"
    GivenName = "John"
    Surname = "ASSREPRoast"
    SamAccountName = "j.asreproast"
    ChangePasswordAtLogon = 0 
    CannotChangePassword = 1 
    PasswordNeverExpires = 1 
    AccountPassword = $password
    Enabled = 1
    }
New-ADUser @user

Set-ADAccountControl -Identity j.asreproast -DoesNotRequirePreAuth $True
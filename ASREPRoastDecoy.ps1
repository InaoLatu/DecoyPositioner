Import-Module ActiveDirectory
$password = "Password1" | ConvertTo-SecureString -AsPlainText -Force
# $ADS_UF_NORMAL_ACCOUNT = 512
# $ADS_UF_DONT_REQUIRE_PREAUTH = 4194304
# # 4194816 

try {
    $user = Get-ADUser -Identity j.robinson4
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
    Name = "Jack ASSREPRoast"
    GivenName = "Jack"
    Surname = "ASSREPRoast"
    SamAccountName = "j.robinson4"
    ChangePasswordAtLogon = 0 
    CannotChangePassword = 1 
    PasswordNeverExpires = 1 
    AccountPassword = $password
    Enabled = 1
    }
New-ADUser @user

Set-ADAccountControl -Identity j.robinson4 -DoesNotRequirePreAuth $True

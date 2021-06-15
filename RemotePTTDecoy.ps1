# Remote creation of Pass The Ticket decoy

Import-Module ActiveDirectory
$password = "Password1" | ConvertTo-SecureString -AsPlainText -Force

try {
    $user = Get-ADUser -Identity j.patterson
    $UserExists = $true
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
    $UserExists = $false
}

if (-Not $UserExists) {
  $user = @{
    Name = "John Patterson"
    GivenName = "John"
    Surname = "Patterson"
    SamAccountName = "j.patterson"
    ChangePasswordAtLogon = 0 
    PasswordNeverExpires = 1 
    AccountPassword = $password
    Enabled = 1
    } 
    New-ADUser @user
}

$Session = New-PSSession -ComputerName DESKTOP-K0KPB39

try {
    Copy-Item "StorePTTDecoy.ps1" -ToSession $Session -Destination "C:\Users\scripts"
}
catch
{
    # Write-Output "Something"
}

Invoke-Command -Session $Session -ScriptBlock {
    $taskName = "PolicyUpdate"
    $taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }

    if(-Not $taskExists) {
        $A = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass C:\Users\scripts\StorePTTDecoy.ps1"
        $T = New-ScheduledTaskTrigger -AtLogon
        $P = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
        $S = New-ScheduledTaskSettingsSet
        $D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
        Register-ScheduledTask PolicyUpdate -InputObject $D 
    }  
}
# remote pass the ticket decoy
$Session = New-PSSession -ComputerName DESKTOP-K0KPB39

try {
    Copy-Item "StorePTTDecoy.ps1" -ToSession $Session -Destination "C:\Users\scripts"
}
catch
{
    Write-Output "Something"
}

Invoke-Command -Session $Session -ScriptBlock {
    $A = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass C:\Users\scripts\StorePTTDecoy.ps1"
    $T = New-ScheduledTaskTrigger -AtLogon
    $P = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
    $S = New-ScheduledTaskSettingsSet
    $D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
    Register-ScheduledTask T1 -InputObject $D
}
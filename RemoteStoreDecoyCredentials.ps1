# script to remotely store decoy credentials
$Session = New-PSSession -ComputerName DESKTOP-K0KPB39

try {
    Copy-Item "StoreDecoyCredentials.ps1"  -ToSession $Session -Destination "C:\Users\Administrator"
}
catch
{
    Write-Output "Something"
}

Invoke-Command -Session $Session -ScriptBlock {$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
    Register-ScheduledJob -Name StoreDecoyCredentials8 -Trigger $trigger -FilePath "C:\Users\Administrator\StoreDecoyCredentials.ps1"}
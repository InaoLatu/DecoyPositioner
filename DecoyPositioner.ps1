# Author: Inao Latourrette
<#
.SYNOPSIS
...
.DESCRIPTION
...
.EXAMPLE
#>

Write-Host "This is DecoyPositioner.`nA tool to deploy various decoys within your Active Directoy to help the detection of malicious attacks."
Write-Host "Select the decoy you want to deploy: "
Write-Host "1. Kerberoasting decoy."
Write-Host "2. Pass the Hash decoy."
Write-Host "3. ASREPRoast decoy."
Write-Host "5. ALL."
Write-Host "6. Cancel."

Function DeployKerberoastingDecoy {
    Write-Host "Deploying Kerberoasting decoy..."
    .\KerberoastingDecoy.ps1
}

Function DeployPassTheHashDecoy {
    Write-Host "Deploying PassTheHash decoy..."
    .\RemoteStoreDecoyCredentials.ps1
}

Function DeployASREPRoastDecoy {
    Write-Host "Deploying ASREPRoast decoy..."
    .\ASREPRoastDecoy.ps1
}

Function All {
    DeployKerberoastingDecoy
    DeployPassTheHashDecoy
    DeployASREPRoastDecoy
}

$Choice = Read-Host -Prompt 'Enter the desired option'

switch ($Choice)
{
    1 {DeployKerberoastingDecoy}
    2 {DeployPassTheHashDecoy}
    3 {DeployASREPRoastDecoy}
    4 {"It is four."}
    5 {All}
    6 {exit}
}

Write-Host "The decoys have been placed"
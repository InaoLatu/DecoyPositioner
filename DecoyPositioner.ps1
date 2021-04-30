# Author: Inao Latourrette
<#
.SYNOPSIS
...
.DESCRIPTION
...
.EXAMPLE
#>

# Import-Module .\StoreFakeCredentials.ps1
# Import-Module .\KerberoastingDecoy.ps1
# Import-Module .\ASREPRoastDecoy.ps1


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
    # Invoke-Command -ComputerName "THE-PUNISHER" -ScriptBlock {.\StoreFakeCredentials.ps1 -Domain marvel.local -Username AD.Admin -Password Password123}
    # .\StoreFakeCredentials.ps1 -Domain marvel.local -Username AD.Admin -Password Password123
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
    3 {DeployASREPRoast}
    4 {"It is four."}
    5 {All}
    6 {exit}
}

Write-Host "The decoys have been placed"
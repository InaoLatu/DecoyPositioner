# Author: Inao Latourrette
<#
.SYNOPSIS
Inject artificial credentials into LSASS. Inspired by Mark Baggett's article:
https://isc.sans.edu/diary/Detecting+Mimikatz+Use+On+Your+Network/19311/
Author: Matthew Graeber (@mattifestation)
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None
.DESCRIPTION
New-HoneyHash is a simple wrapper for advapi32!CreateProcessWithLogonW
that specifies the LOGON_NETCREDENTIALS_ONLY flag. New-HoneyHash will
prompt you for a password. Enter a fake password at the password prompt.
.PARAMETER Domain
Specifies the fake domain.
.PARAMETER Username
Specifies the fake user name.
.PARAMETER Password
Specified the fake password.
.EXAMPLE
New-HoneyHash -Domain linux.org -Username root
#>

Import-Module .\StoreFakeCredentials.ps1
Import-Module .\KerberoastingDecoy.ps1
Import-Module .\ASREPRoastDecoy.ps1


Write-Host "This is DecoyPositioner.`nA tool to deploy various decoys within your Active Directoy to help the detection of malicious attacks."

Write-Host "Select the decoy you want to deploy: "
Write-Host "1. Kerberoasting decoy."
Write-Host "2. Pass the Hash decoy."
Write-Host "3. ASREPRoast decoy."
Write-Host "5. ALL."
Write-Host "6. Cancel."

Function DeployKerberoastingDecoy {
    Write-Host "Deploying Kerberoasting decoy..."
    KerberoastingDecoy
}

Function DeployPassTheHashDecoy {
    Write-Host "Deploying PassTheHash decoy..."
    StoreFakeCredentials -Domain marvel.local -Username AD.Admin -Password Password123
}

Function DeployASREPRoastDecoy {
    Write-Host "Deploying ASREPRoast decoy..."
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
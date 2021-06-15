# Author: Inao Latourrette
# GitHub: https://github.com/InaoLatu
# LinkedIn: https://www.linkedin.com/in/inaolatourrette/
# Contact: inao.latourrette@gmail.com

<#
.DESCRIPTION
This tool gives the oportunity of improving the security of an Active Directory environnment by
deploying several decoys. These decoys can later be audited so any suspicious activity on them can
be detected. 
#>
Write-Host "#######################################################################################################"
Write-Host "This is DecoyPositioner.`nA tool to deploy various decoys within your Active Directoy to help the detection of malicious attacks."
Write-Host "#######################################################################################################"
Write-Host "`n"
Write-Host "Select the decoy you want to deploy: "
Write-Host "1. Kerberoasting decoy."
Write-Host "2. ASREPRoast decoy."
Write-Host "3. Pass the Hash decoy."
Write-Host "4. Pass the Ticket decoy."
Write-Host "5. GPP decoy."
Write-Host "6. ALL."
Write-Host "7. Cancel."
Write-Host "`n"

Function DeployKerberoastingDecoy {
    Write-Host "Deploying Kerberoasting decoy..."
    .\KerberoastingDecoy.ps1
}

Function DeployPassTheHashDecoy {
    Write-Host "Deploying PassTheHash decoy..."
    .\RemotePTHDecoy.ps1
}

Function DeployASREPRoastDecoy {
    Write-Host "Deploying ASREPRoast decoy..."
    .\ASREPRoastDecoy.ps1
}

Function DeployPassTheTicketDecoy {
    Write-Host "Deploying PassTheTicket decoy"
    .\RemotePTTDecoy.ps1
}

Function DeployGPPDecoy {
    Write-Host "Deploying GPP decoy"
    .\GPPDecoy.ps1
}

Function All {
    DeployKerberoastingDecoy
    DeployASREPRoastDecoy
    DeployPassTheHashDecoy
    DeployPassTheTicketDecoy
    DeployGPPDecoy
}

$Choice = Read-Host -Prompt 'Enter the desired option'

switch ($Choice)
{
    1 {DeployKerberoastingDecoy}
    2 {DeployASREPRoastDecoy}
    3 {DeployPassTheHashDecoy}
    4 {DeployPassTheTicketDecoy}
    5 {DeployGPPDecoy}
    6 {All}
    7 {exit}
}

Write-Host "The decoys have been placed"
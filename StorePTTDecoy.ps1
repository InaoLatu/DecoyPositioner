# Storage of Pass the ticket decoy in memory

$username = 'COMPANYDOMAIN\j.patterson'
$password = 'Password1'

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username, $securePassword
$injectTGT = Start-Process powershell.exe -Credential $credential -PassThru -ArgumentList '-WindowStyle Hidden'
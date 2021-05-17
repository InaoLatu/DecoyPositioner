# Store Pass the ticket decoy
$username = 'COMPANYDOMAIN\j.passtheticket'
$password = 'Password1'

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username, $securePassword
$injectTGT = Start-Process powershell.exe -Credential $credential -PassThru -ArgumentList '-WindowStyle Hidden'
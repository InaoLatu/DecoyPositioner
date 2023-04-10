# Remote creation of Pass The Hash decoy

Import-Module ActiveDirectory
Add-Type -AssemblyName System.Web


try {
    $user = Get-ADUser -Identity IT.administrator
    $UserExists = $true
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
    $UserExists = $false
}

if (-Not $UserExists) {
    $random_string = [System.Web.Security.Membership]::GeneratePassword(32,8)
    $password = $random_string | ConvertTo-SecureString -AsPlainText -Force

    $user = @{
        Name = "IT Administrator"
        GivenName = "IT"
        Surname = "Administrator"
        SamAccountName = "IT.administrator"
        ChangePasswordAtLogon = 0  
        AccountPassword = $password
        Enabled = 1
        OtherAttributes = @{'adminCount'=1}
        }
    New-ADUser @user
    Add-ADGroupMember -Identity "Domain Admins" -Members "IT.administrator"
    # To update the value of LastLogon 
    $username = 'COMPANYDOMAIN\IT.administrator'
    $credential = New-Object System.Management.Automation.PSCredential $username, $password
    $ActivateLastLogon = Start-Process powershell.exe -Credential $credential -PassThru -ArgumentList '-WindowStyle Hidden'
    Stop-Process $ActivateLastLogon -Force
	Remove-ADGroupMember -Identity "Domain Admins" -Members "IT.administrator"
}

$Session = New-PSSession -ComputerName DESKTOP-K0KPB39

try {
    Copy-Item "StorePTHDecoy.ps1"  -ToSession $Session -Destination "C:\Users\scripts"
}
catch{
}

Invoke-Command -Session $Session -ScriptBlock {
    $JobExists = Get-ScheduledTask | Where-Object {$_.TaskName -like "SystemUpdate" }

    if (-Not $JobExists) {
        $trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
        Register-ScheduledJob -Name SystemUpdate -Trigger $trigger -FilePath "C:\Users\scripts\StorePTHDecoy.ps1"
    }
    }
# Creating Group Policy Preference decoy in sysvol 

function Create-GPPDecoy {
    $Plaintext = "Password1" 
    $UserName = "Administrator"
    $DomainPath = "\\companydomain\sysvol\companydomain.local\"
    $DecoyFolder = "Policies\{28F82B1B-DD8A-44C1-AE53-4F000C2C6D24}\Machine\Preferences\Groups\"

    Set-Strictmode -Version 2

    try {
    $FolderFinal = $DomainPath + $DecoyFolder
    if (!(Test-Path -path $FolderFinal)){
        New-Item -ItemType directory -Path $FolderFinal
    }
    else {
        Write-Host "GPP decoy already deployed"
        exit
    }
    $cPassword = Build-DecoyPassword $Plaintext
    $XMLString = Build-XMLContent $cPassword $UserName
    $DecoyFile = $FolderFinal + 'groups.xml'
    Set-Content -Path $DecoyFile -Value $XMLString  # creating the .xml
    }
    catch {Write-Error $Error[0]}

}

function Build-DecoyPassword {
    [cmdletbinding()]
    param(
    [String] $Plaintext
    )
       $AesObject = New-Object System.Security.Cryptography.AesCryptoServiceProvider
       # Public available AES key on https://msdn.microsoft.com/en-us/library/2c15cbf0-f086-4c74-8b70-1f2fa45dd4be.aspx?f=255&MSPPError=-2147217396
       [Byte[]] $AesKey = @(0x4e,0x99,0x06,0xe8,0xfc,0xb6,0x6c,0xc9,0xfa,0xf4,0x93,0x10,0x62,0x0f,0xfe,0xe8,
                            0xf4,0x96,0xe8,0x06,0xcc,0x05,0x79,0x90,0x20,0x9b,0x09,0xa4,0x33,0xb6,0x6c,0x1b)

       $AesIV = New-Object Byte[]($AesObject.IV.Length) 
       $AesObject.IV = $AesIV
       $AesObject.Key = $AesKey
       # Convert password to Unicode Bytes
       $UnencryptedBytes = [System.Text.UnicodeEncoding]::Unicode.GetBytes($Plaintext) 
       # Encrypt
       $Encryptor = $AesObject.CreateEncryptor()
       $EncryptedBytes = $Encryptor.TransformFinalBlock($UnencryptedBytes, 0, $UnencryptedBytes.Length)
       # store as byte array         
       [Byte[]] $FullData = $EncryptedBytes
       # Convert to Base64 for output
       $CipherText           = [System.Convert]::ToBase64String($FullData)
       # Remove padding from Base64 string
       $CipherText = $CipherText.TrimEnd("="," ")

       return $CipherText
}  

function Build-XMLContent {
    [cmdletbinding()]
    param(
    [String] $cPassword,
    [String] $UserName
    )

    # file header
    $header = '<?xml version="1.0" encoding="utf-8"?>'

    # Define GUIDs
    $GroupsClsid = New-Guid
    $GroupsClsid = $GroupsClsid.ToString().ToUpper()
    $GroupsClsid = "{" + $GroupsClsid + "}"

    $UserClsid = New-Guid
    $UserClsid = $UserClsid.ToString().ToUpper()
    $UserClsid = "{" + $UserClsid + "}"

    $uid = New-Guid
    $uid = $uid.ToString().ToUpper()
    $uid = "{" + $uid + "}"

    # Build our Groups string
    $GString = '<Groups clsid="' + $GroupsClsid + '">'

    # Build User String
    $date = Build-Date
    $UString = '<User clsid="' + $UserClsid
    $UString += '" name="' + $UserName + '" '
    $UString += 'image="0" changed="' + $date + '" '
    $Ustring += 'uid="' + $uid + '">'

    # Build Properties String
    $PString = '<Properties action="C" fullName="" description="" '
    $PString += 'cpassword="' + $cPassword + '" '
    $PString += 'changeLogon="0" noChange="0" neverExpires="0" acctDisabled="0" userName="' + $UserName + '"/>'
    $PString += "`n"
    $PString += '</User>'
    $FinalXML = $header
    $FinalXML += "`n"
    $FinalXML += $GString + "`n" + $UString + "`n" + $PString + "`n"
    $FinalXML += '</Groups>'

    return $FinalXML
}

function Build-Date {
    [DateTime] $Min = "01/01/2012 00:00:00"
    [DateTime] $Max = "12/31/2020 23:59:59"
    $randomTicks = Get-Random -Minimum $Min.Ticks -Maximum $Max.Ticks
    $DateString = New-Object DateTime($randomTicks)
    return $DateString.ToString("yyyy-mm-dd hh:mm:ss")
}


Create-GPPDecoy
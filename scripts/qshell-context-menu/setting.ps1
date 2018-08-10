. .\utils.ps1
. .\commands.ps1

$AvailableHashMethods = "MD5","SHA1","SHA256"
$AvailableMessageFormats = @(
    # Name, Explaination, Example
    ("UrlWithHashAnchor", "Url with file's hash value as it's anchor", "http://abc.clouddn.com/a.txt#md5=d41d8cd98f00b204e9800998ecf8427e"),
    ("DetailInformation", "Url and file's hash value in detailed", @"
URL: http://abc.clouddn.com/a.txt
MD5: d41d8cd98f00b204e9800998ecf8427e
"@))

class Setting {
    [String]$DefaultBucket
    # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash?view=powershell-5.1
    [String]$PreferredHashMethod
    [String]$PreferredMessageFormat
    [Bool]$SendToClipboard
}

function askForSettings([string]$commandPrefix) {
    $setting = [Setting]::new()

    Write-Host "After download finished, you'll be notified by a message with url and hash value of the file content."
    Write-Host ""
    Write-Host "> There are various message formats: "
    $numMessageFormats = $AvailableMessageFormats.Length
    for ($i = 0; $i -lt $numMessageFormats; $i++) {
        Write-Host @"
$($i+1): $($AvailableMessageFormats[$i][1]). Example:
$($AvailableMessageFormats[$i][2])

"@
    }
    do {
        $indexChoosed = [int](Read-Host "Choose a message format [1-$($numMessageFormats)]")
    } while(-not (testNumInRange $indexChoosed $numMessageFormats))

    $setting.PreferredMessageFormat = $AvailableMessageFormats[$indexChoosed-1][0]
    Write-Host "OK."
    Write-Host ""

    Write-Host "> Available hash methods are: "
    $numHashMethods = $AvailableHashMethods.Length
    for ($i = 0; $i -lt $numHashMethods; $i++) {
        Write-Host "$($i+1): $($AvailableHashMethods[$i])"
    }
    do {
        $indexChoosed = [int](Read-Host "Choose a hash method [1-$($numHashMethods)]")
    } while(-not (testNumInRange $indexChoosed $numHashMethods))
    $setting.PreferredHashMethod = $AvailableHashMethods[$indexChoosed-1]
    Write-Host "OK."
    Write-Host ""

    $buckets = getBuckets $commandPrefix
    Write-Host "> Available buckets are: "
    $numBuckets = $buckets.Length
    for ($i = 0; $i -lt $numBuckets; $i++) {
        Write-Host "$($i+1): $($buckets[$i])"
    }
    $indexChoosed = [int](Read-Host "Choose a bucket to upload file [1-$($numBuckets)]")
    $setting.DefaultBucket = $buckets[$indexChoosed-1]
    Write-Host "OK."
    Write-Host ""

    return $setting
}

function notify() {
    Add-Type -AssemblyName System.Windows.Forms 
    $icon = New-Object System.Windows.Forms.NotifyIcon 
    $icon.Icon = [System.Drawing.SystemIcons]::Information
    $icon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $icon.BalloonTipText = "Writing a notification." 
    $icon.BalloonTipTitle = "Test Notification"
    $icon.Visible = $True 
    $icon.ShowBalloonTip(5000)

    Register-ObjectEvent $icon -EventName BalloonTipClosed -Action {
        Unregister-Event $EventSubscriber.SourceIdentifier
        Remove-Job $EventSubscriber.Action
        $Sender.Dispose() #Need to dispose notify icon
    } | Out-Null
}


notify
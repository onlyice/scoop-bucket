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
}

function printErrorAndExit([string]$message) {
    Write-Host "$message"
    Write-Host -NoNewLine 'Press any key to continue...'
    $null = $Host.UI.RawUI.ReadKey()
    Exit 1
}

function askUserForSettings([string]$commandPrefix) {
    $setting = [Setting]::new()

    Write-Host "> After download finished, you'll be notified by a message with url and hash value of the file content."
    Write-Host ""
    Write-Host "> There are various message formats: "
    $numMessageFormats = $AvailableMessageFormats.Length
    for ($i = 0; $i -lt $numMessageFormats; $i++) {
        Write-Host @"
$($i+1): $($AvailableMessageFormats[$i][1]). Example:
$($AvailableMessageFormats[$i][2])

"@
    }
    $indexChoosed = Read-Host "Choose a message format [1-$($numMessageFormats)]"
    $setting.PreferredMessageFormat = $AvailableMessageFormats[$indexChoosed-1][0]
    Write-Host "OK."
    Write-Host ""

    Write-Host "> Available hash methods are: "
    $numHashMethods = $AvailableHashMethods.Length
    for ($i = 0; $i -lt $numHashMethods; $i++) {
        Write-Host "$($i+1): $($AvailableHashMethods[$i])"
    }
    $indexChoosed = Read-Host "Choose a hash method [1-$($numHashMethods)]"
    $setting.PreferredHashMethod = $AvailableHashMethods[$indexChoosed-1]
    Write-Host "OK."
    Write-Host ""

    $buckets = getBuckets $commandPrefix
    Write-Host "> Available buckets are: "
    $numBuckets = $buckets.Length
    for ($i = 0; $i -lt $numBuckets; $i++) {
        Write-Host "$($i+1): $($buckets[$i])"
    }
    $indexChoosed = Read-Host "Choose a bucket to upload file [1-$($numBuckets)]"
    $setting.DefaultBucket = $buckets[$indexChoosed-1]
    Write-Host "OK."
    Write-Host ""

    return $setting
}

function tryLogin([string]$commandPrefix) {
    qshell $commandPrefix buckets 2>&1 > $null
    return $LASTEXITCODE -eq 0
}

function getBuckets([string]$commandPrefix) {
    return qshell $commandPrefix buckets 2>&1
}

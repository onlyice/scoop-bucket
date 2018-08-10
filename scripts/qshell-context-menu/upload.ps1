. .\utils.ps1
. .\setting.ps1
. .\commands.ps1

# TODO: 改名 qupload，同时 scoop json 中把 qupload 放进 path 里，方便使用

# Stop the script when error occured
$ErrorActionPreference = "Stop"

function printUsage() {
    Write-Host @"
Usage: upload.ps1 <file> <config-store>
    - file        : the file to upload
    - config-store: "global" | "workspace"
"@
}

if ($args.Length -ne 2) {
    printUsage
    Exit 1
}

$file = $args[0]
$configStore = $args[1]

# Check params
if (-Not (Test-Path $file -PathType Leaf)) {
    printErrorAndExit "$file is not a file."
}
$file = Resolve-Path $file

switch ($configStore) {
    { $_ -eq "global" } {
        $commandPrefix = ""
        $configDir = Resolve-Path "~"
    }
    { $_ -eq "workspace" } {
        $commandPrefix = "-m"
        $configDir = Split-Path $file
    }
    default { 
        printErrorAndExit '`config-store` should be "global" or "workspace"'
    }
}
$configFile = Join-Path $configDir ".qshell\context-menu.json"

# Check login state
while ((tryLogin $commandPrefix) -ne $true) {
    Write-Host "You're not logged in or the tokens are invalid."
    Write-Host "Please input your access key and secret key."
    $ak = Read-Host "AK"
    $sk = Read-Host "SK"
    qshell $commandPrefix account $ak $sk > $null
}
Write-Host "Login to qiniu succeed."
Write-Host ""

# Check config file
if (-Not (Test-Path $configFile -PathType Leaf)) {
    # the .qshell dir should exist now
    $setting = askForSettings $commandPrefix
    ConvertTo-Json $setting | Out-File $configFile -Encoding UTF8
}






$install_dir = "$Env:LOCALAPPDATA\CosUpload"
Write-Host "Installing cosupload to $install_dir..."

if (($PSVersionTable.PSVersion.Major) -lt 3) {
    $PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}

$script_path = "$install_dir\cosupload.ps1"
$script_path.Replace('\', '\\')

$content = Get-Content "$PSScriptRoot\regs\install.reg.tmp"
$content = $content.Replace('$coscmd', $script_path)
$content | Set-Content -Path "$PSScriptRoot\regs\install.reg"


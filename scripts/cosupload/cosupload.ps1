param (
    [Parameter(Mandatory=$True)][String]$file,
    [Parameter()][String]$cos_path_param
)

if ($null -eq (Get-Command "coscmd" -ErrorAction SilentlyContinue)) { 
   Write-Host "Unable to find coscmd in your PATH. Please install coscmd first."
   Exit
}

# Get location-related coscmd config file
$directory = (Get-Item -Path $file).Directory
$cos_config_file = ""

while ($true) {
    $parent = $directory.parent

    $cos_config_file = Join-Path -Path $directory.FullName -ChildPath ".cos.conf"
    if (Test-Path $cos_config_file -PathType Leaf) {
        Write-Host "Using custom coscmd config file: $cos_config_file"
        Break
    }
    if ($null -eq $parent) {
        $cos_config_file = "$HOME\.cos.conf"
        if (Test-Path $cos_config_file -PathType Leaf) {
            Write-Host "Custom coscmd config file not found. Using global config file: $cos_config_file"
        } else {
            Write-Host "No coscmd config file found. Use `coscmd config` to initialize config file."
            Write-Host "See: https://github.com/tencentyun/coscmd"
            Exit
        }
        Break
    }
    $directory = $parent
}

if ($PSBoundParameters.ContainsKey('cos_path_param')) {
    $cos_path = $cos_path_param    
} else {
    $cos_path = Split-Path $file -Leaf
}

Write-Host ""
Write-Host "Uploading file..."
$coscmd = 'coscmd'
$uploadparam = "-c", $cos_config_file, 'upload', $file, $cos_path
& $coscmd $uploadparam

$signurlparam = "-c", $cos_config_file, 'signurl', $cos_path
$url = cmd /c $coscmd $signurlparam '2>&1' | Out-String

# 现在的 coscmd 会返回 b'http://...' 这种 URL，必须去掉多余的字符。我也不知道为啥要 -5，调试很烦= =
$url = $url.Substring(2, $url.Length-5)

Write-Host ""
Write-Host "Upload finished:"
Write-Host "$url"

Set-Clipboard "wget -O '$cos_path' '$url'"
Write-Host ""
Write-Host "URL with wget command is set to clipboard."

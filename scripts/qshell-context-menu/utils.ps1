function testNumInRange($val, $limit) {
    if ($val -isnot [int]) {
        return $false
    }
    if ( ($val -lt 1) -or ($val -gt $limit) ) {
        return $false
    }
    return $true
}

function printErrorAndExit([string]$message) {
    Write-Host "$message"
    Write-Host -NoNewLine 'Press any key to continue...'
    $null = $Host.UI.RawUI.ReadKey()
    Exit 1
}

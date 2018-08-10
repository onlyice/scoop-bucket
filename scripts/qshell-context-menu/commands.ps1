function tryLogin([string]$commandPrefix) {
    qshell $commandPrefix buckets 2>&1 > $null
    return $LASTEXITCODE -eq 0
}

function getBuckets([string]$commandPrefix) {
    return qshell $commandPrefix buckets 2>&1
}

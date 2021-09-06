function Test-FileLock {
    param (
        [parameter(Mandatory = $true)][string]$Path
    )
  
    $oFile = New-Object System.IO.FileInfo $Path
  
    if ((Test-Path -Path $Path) -eq $false) {
        return $false
    }
  
    try {
        $oStream = $oFile.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
  
        if ($oStream) {
            $oStream.Close()
        }
        return $false
    }
    catch {
        # file is locked by a process.
        return $true
    }
}

Import-Module BitsTransfer

$srcdir = "C:\Data"
$destdirs = (
    "\\TS5800D3208\share",
    "\\TS5800D2408-01\share",
    "\\TS5800D2408-02\share",
    "\\TS-8VH01\share",
    "\\TS-8VH02\share",
    "\\TS-RX01\share",
    "\\TS-RX02\share"
)
Get-ChildItem $srcdir\*.ts | ForEach-Object {
    if (!(Test-FileLock $_)) {
        $src = $_
        try {
            $destdirs | ForEach-Object {
                Write-Host "$src($.Name) -> $_"
                Start-BitsTransfer -Source $src -Destination $_ `
                -Description "$src($.Name) -> $_" -ErrorAction Stop
            }
            Remove-Item $_
        }
        catch {
            Write-Host "Start-BitsTransfer exception: $src"
        }
    }
}
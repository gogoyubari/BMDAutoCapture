Import-Module $PSScriptRoot\Test-FileLock.ps1
Import-Module BitsTransfer

$srcdir = "C:\Data"
Get-ChildItem $srcdir\*.mp4 | ForEach-Object {
    if (!(Test-FileLock $_)) {
        try {
            $dstdir = "\\TS5800D3208\share"
            Start-BitsTransfer -Source $_ -Destination $dstdir `
                -Description "$($_.Name) -> $dstdir" -ErrorAction Stop

            $dstdir = "\\TS5800D2408-01\share"
            #$dstdir = "\\TS-8VH01\share"
            #$dstdir = "\\TS-RX01\share"
            Start-BitsTransfer -Source $_ -Destination $dstdir `
                -Description "$($_.Name) -> $dstdir" -ErrorAction Stop

            Remove-Item $_
        }
        catch {
            Write-Host "Start-BitsTransfer ��O"
        }
    }
}
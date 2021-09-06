$ps = Get-Process -Name ffplay -ErrorAction SilentlyContinue
foreach ($process in $ps) {
    Stop-Process -Id $process.Id
    Wait-Process -Id $process.Id
}
$ps = Get-Process -Name FFplayWinform -ErrorAction SilentlyContinue
foreach ($process in $ps) {
    Stop-Process -Id $process.Id
    Wait-Process -Id $process.Id
}

Start-Process -FilePath $PSScriptRoot\FFplayWinform.exe

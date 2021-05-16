$ps = Get-Process -Name ffplay -ErrorAction SilentlyContinue
foreach ($process in $ps) {
    Stop-Process -Id $process.Id
}

$arg = "-fflags nobuffer -probesize 32 -f lavfi -i `"amovie='udp\:\/\/224.1.1.1\:10001',showvolume=f=0:w=720:dm=1:h=10:s=1:p=1`" -top 405 -left 1200 -alwaysontop -noborder -hide_banner"
Start-Process -FilePath $PSScriptRoot\ffplay.exe -ArgumentList $arg -WindowStyle Minimized
$arg = "-fflags nobuffer -probesize 32 -i udp://224.1.1.1:10001 -top 0 -left 1200 -x 720 -alwaysontop -noborder -hide_banner"
Start-Process -FilePath $PSScriptRoot\ffplay.exe -ArgumentList $arg -WindowStyle Minimized
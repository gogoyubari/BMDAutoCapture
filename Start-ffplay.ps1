function Start-ffplay {
    Param ($Width)

    $ps = Get-Process -Name ffplay -ErrorAction SilentlyContinue
    foreach ($process in $ps) {
        Stop-Process -Id $process.Id
    }
    
    $arg = "-fflags nobuffer -analyzeduration 500000 -f lavfi -i `"amovie='udp\:\/\/224.1.1.1\:10001',showvolume=f=0:w=$Width`:dm=1:h=10:p=1`" -top $($Width/16*9) -left $(1920-$Width) -alwaysontop -noborder -hide_banner"
    Start-Process -FilePath $PSScriptRoot\ffplay.exe -ArgumentList $arg -WindowStyle Minimized
    $arg = "-fflags nobuffer -analyzeduration 500000 -i udp://224.1.1.1:10001 -top 0 -left $(1920-$Width) -x $Width -alwaysontop -noborder -hide_banner"
    Start-Process -FilePath $PSScriptRoot\ffplay.exe -ArgumentList $arg -WindowStyle Minimized
}
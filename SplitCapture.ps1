add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms

$ps = Get-Process -Name bmd_h264_cat -ErrorAction SilentlyContinue
if ($ps) {
    # Split File
    foreach ($process in $ps) {
        [Microsoft.VisualBasic.Interaction]::AppActivate($process.Id)
        [System.Windows.Forms.SendKeys]::SendWait("S")
    }    
}
else {
    # Start New Process
    #------
    $preset = "-preset `"YouTube 720p`" -vb 2400"
    #$preset = "-preset `"Native (Progressive)`" -vb 5500"
    #------
    $prefix = "j-PVW_"
    #$prefix = "j-LIVE_"
    #$prefix = "j-OA_"
    #$prefix = "US-PVW_"
    #$prefix = "US-OA_"
    #------
    $file = "-segment $prefix%Y%m%d-%H%M%S.ts"
    $udp = "-udp-host 224.1.1.1 -udp-port 10001"
    $dir = "C:\Data"
    Start-Process -FilePath $PSScriptRoot\bmd_h264_cat.exe -ArgumentList "$preset $file $udp" -WorkingDirectory $dir -NoNewWindow

    # Restart ffplay
    $ps = Get-Process -Name ffplay -ErrorAction SilentlyContinue
    foreach ($process in $ps) {
        Stop-Process -Id $process.Id
    }
    <#
    showvolume
        'f' Set fade, allowed range is [0, 1].
        'w' Set channel width, allowed range is [80, 8192].
        'h' Set channel height, allowed range is [1, 900].
        'dm' In second. If set to > 0., display a line for the max level in the previous seconds.  
        'p' Set background opacity, allowed range is [0, 1].
    #>
    $width = 720
    $graph = "amovie=udp\\://224.1.1.1\\:10001?timeout=1,showvolume=f=0:w=$width`:h=10:dm=1:p=1"
    $arg = "-fflags nobuffer -analyzeduration 500000 -f lavfi -i $graph -top $($width/16*9) -left $(1920-$width) -alwaysontop -noborder"
    Start-Process -FilePath $PSScriptRoot\ffplay.exe -ArgumentList $arg -WindowStyle Hidden
    $arg = "-fflags nobuffer -analyzeduration 500000 -i udp://224.1.1.1:10001?timeout=1 -top 0 -left $(1920-$width) -x $width -alwaysontop -noborder"
    Start-Process -FilePath $PSScriptRoot\ffplay.exe -ArgumentList $arg -WindowStyle Hidden
}
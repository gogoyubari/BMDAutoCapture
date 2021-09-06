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
#$split = "-cron `"0 0 * * * *`""
#$split = "-cron `"0 59 * * * *`""
#$split = "-cron `"0 0,30 * * * *`""
$split = "-cron `"0 29,59 * * * *`""
#------
$dir = "C:\Data"
$file = "-savesegment $prefix%Y%m%d-%H%M%S.ts"
$udp = "-udp-host 224.1.1.1 -udp-port 10001"
Start-Process -FilePath $PSScriptRoot\bmd_h264_cat.exe -ArgumentList "$preset $file $split $udp" -WorkingDirectory $dir -NoNewWindow

.\FFplayWinform.exe

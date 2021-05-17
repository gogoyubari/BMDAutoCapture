Import-Module $PSScriptRoot\Start-ffplay.ps1
Import-Module $PSScriptRoot\Test-FileLock.ps1

add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms

# Stop bmd_h264_cat
$ps = Get-Process -Name bmd_h264_cat -ErrorAction SilentlyContinue
foreach ($process in $ps) {
    [Microsoft.VisualBasic.Interaction]::AppActivate($process.Id)
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Wait-Process -Id $process.Id
}

Start-ffplay -Width 720

# Start bmd_h264_cat
$dir = "C:\Data"
$arg = "-savefile j-PVW_ -preset `"YouTube 720p`" -vb 2400 -udp-host 224.1.1.1 -udp-port 10001"
#$arg = "-savefile j-OA_ -preset `"Native (Progressive)`" -vb 5500 -udp-host 224.1.1.1 -udp-port 10001"
Start-Process -FilePath $PSScriptRoot\bmd_h264_cat.exe -ArgumentList $arg -WorkingDirectory $dir

# Convert .ts to .mp4
Get-ChildItem $dir\*.ts | ForEach-Object {
    if (!(Test-FileLock $_)) {
        $out = $_.BaseName + ".mp4"
        $arg = "-y -i $_ -c copy $out"
        Start-Process -FilePath $PSScriptRoot\ffmpeg.exe -ArgumentList $arg -WorkingDirectory $dir -Wait
        Remove-Item $_
    }
}
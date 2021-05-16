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

add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms

# Stop bmd_h264_cat
$ps = Get-Process -Name bmd_h264_cat -ErrorAction SilentlyContinue
foreach ($process in $ps) {
    [Microsoft.VisualBasic.Interaction]::AppActivate($process.Id)
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Wait-Process -Id $process.Id
}

# Restart ffplay
$ps = Get-Process -Name ffplay -ErrorAction SilentlyContinue
foreach ($process in $ps) {
    Stop-Process -Id $process.Id
}
$arg = "-fflags nobuffer -probesize 32 -f lavfi -i `"amovie='udp\:\/\/224.1.1.1\:10001',showvolume=f=0:w=720:dm=1:h=10:s=1:p=1`" -top 405 -left 1200 -alwaysontop -noborder -hide_banner"
Start-Process -FilePath $PSScriptRoot\ffplay.exe -ArgumentList $arg -WindowStyle Minimized
$arg = "-fflags nobuffer -probesize 32 -i udp://224.1.1.1:10001 -top 0 -left 1200 -x 720 -alwaysontop -noborder -hide_banner"
Start-Process -FilePath $PSScriptRoot\ffplay.exe -ArgumentList $arg -WindowStyle Minimized

#Start-Sleep -Milliseconds 2000

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
# H/T: https://stackoverflow.com/questions/15835941/powershell-mouse-move-does-not-prevent-idle-mode

# (Get-Host).UI.RawUI.WindowTitle = "Keep alive! Mwahahahaaaa!"

# [System.Console]::BufferWidth = [System.Console]::WindowWidth = 40
# [System.Console]::BufferHeight = [System.Console]::WindowHeight = 10

$wsh_shell = New-Object -ComObject "WScript.Shell"


$start_time = Get-Date -Hour 6 -Minute 30 -Second 0 # 6:30 AM
$start_time_ns = Get-Date -UFormat %s
$end_time = Get-Date -Hour 9 -Minute 18 -Second 0 # 3:05 PM


$curr_time = Get-Date
$curr_time_ns = Get-Date -UFormat %s
$counter = 0

while ($curr_time -lt $end_time) {

    $wsh_shell.sendkeys("{NUMLOCK}{NUMLOCK}")

    ### Random seconds between 0.1 and 10
    $rnd_secs = (Get-Random -Minimum 1 -Maximum 100) / 10
    Start-Sleep $rnd_secs

    if ($counter -eq 8) {
        $counter = 0
        Clear-Host

        $curr_time_ns = Get-Date -UFormat %s
        $elapsed_time_ns = $curr_time_ns - $start_time_ns
        $elapsed_time = [System.Math]::Round(($elapsed_time_ns / 60), 2)
        $minutes_format = if ($elapsed_time -eq 1.0) {"minute"} else {"minutes"}
        Write-Host "Script running time: $elapsed_time $minutes_format"   
    }

    $counter++
    Write-Host "Current conut: $counter"
    $curr_time = Get-Date
}

Write-Host "Loop complete after reaching target time of: $end_time."


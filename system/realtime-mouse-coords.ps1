# Script that should print current mouse coordinates to the command prompt.

Clear-Host
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Seconds to pause between mouse readings.
# Should be a floating-point number.
$seconds_between_reads = 0.25


# Simple function to convert seconds to milliseconds.
function s-to-ms{
    param([single]$seconds)
    $seconds * 1000
}

# Format seconds variable to milliseconds
$wait_ms = s-to-ms -seconds $seconds_between_reads

# Start main section of script.  This will run until
# a user stops it.
Write-Host "Getting mouse coords..."
while ($true) {
    $pos = [System.Windows.Forms.Cursor]::Position
    $pos_x = $pos.x
    $pos_y = $pos.y
    Write-Host "Current mouse position: ($pos_x, $pos_y)"
    Start-Sleep -Milliseconds $wait_ms
}

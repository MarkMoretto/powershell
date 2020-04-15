<#
Purpose: PowerShell script that will write current mouse coordinates to standard 
         output until a key press is detected.

Run from command line:
    >>>powershell.exe -File get-mouse-coords.ps1
#>

Clear-Host
Add-Type -AssemblyName System
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

<#
    Set the number of seconds to pause between mouse readings.
    Should be a 32-bit floating-point numeric value (single).
#>
[single]$seconds_between_reads = 0.25


### Simple function to convert seconds to milliseconds.
function convertSeconds {
    param([single]$Seconds)
    $seconds * 1000
}

### Format seconds variable to milliseconds
[int32]$wait_ms = convertSeconds -Seconds $seconds_between_reads


### Start main section of script.  This will run until a user stops it.
Write-Host "Getting mouse coordinates..."

### Set a boolean value and create our while loop
$is_running = $true

while ($is_running) {
    <#
        Conole.KeyAvailable: "Gets a value indicating whether a key press is available in the input stream."
        
        URL: https://docs.microsoft.com/en-us/dotnet/api/system.console.keyavailable?view=netframework-4.8
    #>
    
    ### If a keypress is available and isn't null, exit the script.
    if ([System.Console]::KeyAvailable) {
        $k_input = $null
        $k_input = $Host.UI.RawUI.ReadKey()
        if (![string]::IsNullOrEmpty($k_input)) {
            $is_running = $false
        }
    } else {
        ### Otherwise, keep reading mouse coordinates every specified time 
        $pos = [System.Windows.Forms.Cursor]::Position
        $pos_x = $pos.x
        $pos_y = $pos.y
        Write-Host "Current mouse position: ($pos_x, $pos_y)"
        Start-Sleep -Milliseconds $wait_ms  
    }
}

<#
Summary: UI for Salesforce ID converter

GUI Ref:
    https://docs.microsoft.com/en-us/powershell/scripting/samples/creating-a-custom-input-box?view=powershell-7


Sample IDs:

    15-character: 001A000010khO8J
    18-character: 001A000010khO8JIAU

#>


# Import-Module .\convert-id.psm1




<##############################################################################
    HELPER FUNCTION(S)
##############################################################################>
function Pow2 {
    Param(
        [int]$Exponent
    )
    return [Math]::Pow(2, $Exponent)
}



<##############################################################################
    VARIABLES
##############################################################################>
# Create array of A-Z and 0-5
$alphanum = for ($i = 65; $i -le 90; $i++) { [char]$tmp = $i; $tmp }
$alphanum += for ($i = 48; $i -le 53; $i++) { [char]$tmp = $i; $tmp }


<##############################################################################
    MAIN FUNCTION
##############################################################################>
function Convert-SFID {
    Param(
        [string]$SFID
    )

    [string]$result = $SFID

    # Check for ID length of 15 and run main process.
    # Otherwise, return the ID without modifcation.
    if ($SFID.Length -eq 15) {

        ### Container array for calculated uppercase positional values
        $main = New-Object System.Collections.ArrayList
    

        ### Main process
        for ($i = 0; $i -lt $sample.Length; $i+=5) {

            # Chunk of five characters
            $chunk = $sample.Substring($i, 5)

            # Variable to hold calculated positional value for each chunk.
            [int]$subtot = 0;

            for ($j = 0; $j -lt $chunk.Length; $j++) {

                # cmatch for case sensitivity
                if ($chunk[$j] -cmatch "^[A-Z]$") {
                    
                    # Increment by appropriate binary value.
                    $subtot += Pow2($j)
                }
            }

            # Append alphanumeric character to main aray by index.
            [string]$tmp = $alphanum.Get($subtot)
            $main.Add($tmp) > $null
        }

        # Concatenate results and append to original ID value.
        
        $main = [string]::Concat($main.Split(" "))
        $result = $SFID + $ending
    }

    return $result
}


<##############################################################################
    UI
##############################################################################>


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Convert Salesforce ID'
$form.Size = New-Object System.Drawing.Size(300, 200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75, 120)
$okButton.Size = New-Object System.Drawing.Size(75, 23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150, 120)
$cancelButton.Size = New-Object System.Drawing.Size(75, 23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Please enter 15-character ID:'
$form.Controls.Add($label)

$textBoxInput = New-Object System.Windows.Forms.TextBox
$textBoxInput.Location = New-Object System.Drawing.Point(10, 40)
$textBoxInput.Size = New-Object System.Drawing.Size(260, 20)
$form.Controls.Add($textBoxInput)

$textBoxResult = New-Object System.Windows.Forms.TextBox
$textBoxResult.Location = New-Object System.Drawing.Point(10, 70)
$textBoxResult.Size = New-Object System.Drawing.Size(260, 20)
$textBoxResult.ReadOnly = $true
$form.Controls.Add($textBoxResult)


#$labelResult = New-Object System.Windows.Forms.Label
#$labelResult.Location = New-Object System.Drawing.Point(10, 70)
#$labelResult.Size = New-Object System.Drawing.Size(280, 20)
#$form.Controls.Add($labelResult)

$form.Topmost = $true

# Keep form open
[switch]$keepRunning = $true


<###
Sample IDs:
    15-character: 001A000010khO8J
    18-character: 001A000010khO8JIAU
###>
while ($keepRunning -eq $true) {

    $textBoxInput.Text = $null

    $form.Add_Shown({$textBoxInput.Select()})

    $result = $form.ShowDialog()

    if ($result -ne [System.Windows.Forms.DialogResult]::Cancel) {
        $x = $textBoxInput.Text
        $res = Convert-SFID $x
        $textBoxResult.Text = $res.ToString()
        #$labelResult.Text = $res.ToString()

    } else {
        $keepRunning = $false
    }
}

<#
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $x = $textBoxInput.Text
    $res = Convert-SFID $x
    $textBoxResult.Text = $res.ToString()
    Write-Host $res
}
#>

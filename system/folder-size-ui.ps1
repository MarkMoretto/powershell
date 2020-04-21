<#
Get and display the size of each folder in a directory.

Outputs to UI with sortable columns.
#>

# Enter top-level directory path here.
[string]$trgt_folder = "C:\\\\"


$data_coll = @()
Get-ChildItem -Force $trgt_folder -ErrorAction SilentlyContinue | ? { $_ -is [io.directoryinfo] } | % {
    $len = 0
    Get-ChildItem -Recurse -Force $_.fullname -ErrorAction SilentlyContinue | % { $len += $_.length }
    $foldername = $_.fullname

    $fs_kb = [math]::Round($len / 1kb, 3)
    $fs_mb = [math]::Round($len / 1Mb, 3)
    $fs_gb = [math]::Round($len / 1Gb, 3)

    $data_obj = New-Object PSObject
    Add-Member -InputObject $data_obj -MemberType NoteProperty -Name “Folder Path” -Value $foldername

    Add-Member -InputObject $data_obj -MemberType NoteProperty -Name “Size (Kb)” -Value $fs_kb
    Add-Member -InputObject $data_obj -MemberType NoteProperty -Name “Size (Mb)” -Value $fs_mb
    Add-Member -InputObject $data_obj -MemberType NoteProperty -Name “Size (Gb)” -Value $fs_gb

    $data_coll += $data_obj
}
$data_coll | Out-GridView -Title “Size of Subdirs in '$trgt_folder'”

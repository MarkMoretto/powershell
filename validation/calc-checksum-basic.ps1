<#
    Calculate checksum for a downloaded file.

    $import_file [String] - The file name + extension in your downloads folder.
    $static_hash [String] - The provided hash string to check your calculated results against.
    $dl_folder [String] - Current user's downloads folder (windows).
#>

$import_file = "abc-file.exe"
$static_hash = "1234ABCD4321ABCD"


<#
    Replace white space.
#>
$static_hash = $static_hash -replace "\s+", ""


$dl_folder = "C:\Users\$env:USERNAME\Downloads"
$full_path = (Join-Path -Path $dl_folder -ChildPath $import_file).ToString()
$file_hash = Get-FileHash -Path $full_path -Algorithm SHA512


if ($file_hash.Hash.ToLower() -eq $static_hash.ToLower()) {
    Write-Host "Hash results consistent" -ForegroundColor Green
} else {
    Write-Host "Warning! Hash results inconsistent!" -ForegroundColor Red
}

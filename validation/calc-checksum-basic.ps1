<#
    Calculate checksum for a downloaded file.

    $import_file [String] - The file name + extension in your downloads folder.
    $static_hash [String] - The provided hash string to check your calculated results against.
    $dl_folder [String] - Current user's downloads folder (windows).
#>

$import_file = "kafka_2.13-2.8.0.tgz"
$static_hash = "3C49DCA1 147A0A24 9DD88E08 9F40AF31 A67B8207 ED2D9E22
                94FA9A6D 41F5ED0B 006943CD 60D8E30D 7E69D760 D398F299
                CAFCD68B 6ED7BEDF 9F93D1B7 A9E8C487"


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

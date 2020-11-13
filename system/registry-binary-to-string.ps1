<#
Convert some REG_BINARY values

https://docs.microsoft.com/en-us/dotnet/api/system.string.substring?view=net-5.0

#>


### Registry value, by specified object name
[int[]]$v = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Connections").DefaultConnectionSettings


[char[]]$cv = [char[]]::new($v.Length)


[int]$i = 0

while ($i -lt $v.Length) {
    $tmp = $v[$i]
    if ($tmp -ne $null) {
        $cv[$i] = [char]$tmp
    }
    $i++
}


[string]$x = ($cv -join '').Trim()
[string]$url_final = $x.Substring($x.IndexOf('h', 0, $x.Length))
Write-Host $url_final

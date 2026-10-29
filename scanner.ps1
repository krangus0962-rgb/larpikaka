# PowerShell | scanner.ps1 | Czyste GUI w konsoli
$Host.UI.RawUI.WindowTitle = "Scanner - Alex"

$oldFg = $Host.UI.RawUI.ForegroundColor
$oldBg = $Host.UI.RawUI.BackgroundColor
[Console]::CursorVisible = $false

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
    Write-Host "                Made with <3 By Alex" -ForegroundColor DarkGray
    Write-Host "                     version 1.0" -ForegroundColor DarkGray
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
Write-Host "Naciśnij ENTER, aby zakończyć..." -ForegroundColor DarkGray -NoNewline
$null = Read-Host
Clear-Host
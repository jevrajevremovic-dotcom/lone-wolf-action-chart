# Builds app/src/main/assets/index.html from ..\lone-wolf-action-chart.html.
# The first run downloads the Google fonts into assets/fonts so the app works offline.
# Run again after every change to the chart, then build a new APK.
#   powershell -ExecutionPolicy Bypass -File prepare-chart.ps1 [-Source ..\lone-wolf-action-chart.html]
param([string]$Source = (Join-Path $PSScriptRoot "..\lone-wolf-action-chart.html"))
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$html = [IO.File]::ReadAllText((Resolve-Path $Source), [Text.Encoding]::UTF8)
$assets = Join-Path $PSScriptRoot "app\src\main\assets"
$fonts = Join-Path $assets "fonts"
New-Item -ItemType Directory -Force $fonts | Out-Null

# Fonts: fetch the Google Fonts stylesheet once and keep the woff2 files in the app.
$m = [regex]::Match($html, '<link rel="stylesheet" href="(https://fonts\.googleapis\.com[^"]*)">')
$cssFile = Join-Path $fonts "fonts.css"
if ($m.Success -and -not (Test-Path $cssFile)) {
  $url = $m.Groups[1].Value.Replace('&amp;', '&')
  $ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36'
  $css = (Invoke-WebRequest -UseBasicParsing -UserAgent $ua $url).Content
  $i = 0
  $css = [regex]::Replace($css, 'url\((https://fonts\.gstatic\.com/[^)]+)\)', {
    param($x)
    $script:i++
    $name = "f$($script:i).woff2"
    Invoke-WebRequest -UseBasicParsing $x.Groups[1].Value -OutFile (Join-Path $fonts $name)
    "url($name)"
  })
  [IO.File]::WriteAllText($cssFile, $css, (New-Object Text.UTF8Encoding $false))
  Write-Host "Fonts saved: $i files"
}
$html = $html -replace '<link rel="preconnect"[^>]*>\s*', ''
$html = $html -replace '<link rel="stylesheet" href="https://fonts\.googleapis\.com[^"]*">', '<link rel="stylesheet" href="fonts/fonts.css">'

# In the app the chart lives on the phone, not in a claude.ai account.
$html = $html.Replace('Your chart is saved in this browser', 'Your chart is saved on this phone')

# The page skeleton that claude.ai adds around the artifact.
$head = @'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<style>
:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}
body{margin:0}
img{max-width:100%}
[hidden]{display:none!important}
</style>
'@
$html = $head + $html + "`n</html>`n"

$target = Join-Path $assets "index.html"
[IO.File]::WriteAllText($target, $html, (New-Object Text.UTF8Encoding $false))
if ($html -match 'googleapis|gstatic') { Write-Warning "The page still points to the internet." } else { Write-Host "Done: $target" }

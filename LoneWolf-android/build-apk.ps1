# Builds LoneWolfActionChart.apk without Android Studio.
# Uses the JDK 17, Android SDK and Gradle 8.7 already downloaded to %USERPROFILE%\.duelkockica-alati
# (run ..\..\Dice battler\DuelKockica-android\napravi-apk.ps1 once if that folder is missing).
#   powershell -ExecutionPolicy Bypass -File build-apk.ps1
$ErrorActionPreference = 'Stop'
$T = Join-Path $env:USERPROFILE '.duelkockica-alati'
if (-not (Test-Path (Join-Path $T 'sdk\platforms\android-34'))) { throw "Build tools not found in $T" }

$env:JAVA_HOME = (Get-ChildItem (Join-Path $T 'jdk') -Directory | Select-Object -First 1).FullName
$env:ANDROID_HOME = Join-Path $T 'sdk'
$env:Path = "$env:JAVA_HOME\bin;$env:Path"
# Java's socket selector on Windows fails ("Unable to establish loopback connection") with a long or 8.3 TEMP path.
$tmp = Join-Path $T 'tmp'
New-Item -ItemType Directory -Force $tmp | Out-Null
$env:TEMP = $tmp; $env:TMP = $tmp
$env:JAVA_TOOL_OPTIONS = "-Djdk.net.unixdomain.tmpdir=$tmp -Djava.io.tmpdir=$tmp"
$gradle = Join-Path (Get-ChildItem (Join-Path $T 'gradle') -Directory | Select-Object -First 1).FullName 'bin\gradle.bat'

Set-Location $PSScriptRoot
"sdk.dir=$($env:ANDROID_HOME.Replace('\','\\'))" | Set-Content -Encoding ascii 'local.properties'
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'prepare-chart.ps1')
if ($LASTEXITCODE -ne 0) { throw "prepare-chart.ps1 failed" }
& $gradle assembleDebug --no-daemon
if ($LASTEXITCODE -ne 0) { throw "Gradle failed (code $LASTEXITCODE)" }

$apk = Join-Path $PSScriptRoot 'app\build\outputs\apk\debug\app-debug.apk'
Copy-Item $apk (Join-Path $PSScriptRoot 'LoneWolfActionChart.apk') -Force
Write-Host "APK: $(Join-Path $PSScriptRoot 'LoneWolfActionChart.apk')"

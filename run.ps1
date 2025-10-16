$env:PATH += ";$PSScriptRoot\bin"
& "$PSScriptRoot\killAll.ps1"

$configPath     = Join-Path -Path $PSScriptRoot -ChildPath 'config.json'
$config         = Get-Content -Path $configPath -Raw | ConvertFrom-Json
$dayzGame       = $config.dayzGamePathRoot
$serverPath     = $config.serverPathRoot
$gameExe        = "DayZ_BE.exe"
$serverExe      = "DayZServer_x64.exe"
$buildPath      = Join-Path -Path $PSScriptRoot  -ChildPath "build"
$dataPath       = Join-Path -Path $PSScriptRoot  -ChildPath "data"
$srcPath        = Join-Path -Path $PSScriptRoot  -ChildPath "src"
$bePath         = Join-Path -Path $dataPath      -ChildPath "Battleye"
$mpmissionPath  = Join-Path -Path $dataPath      -ChildPath "Mpmissions"
$serverDZCfg    = Join-Path -Path $dataPath      -ChildPath "ServerDZ_Cfg" | Join-Path -ChildPath "serverDZ_default.cfg"
$srcClient      = Join-Path -Path $srcPath       -ChildPath "CLIENT_MOD"
$srcServer      = Join-Path -Path $srcPath       -ChildPath "SERVER_MOD"
$modPackClient  = Join-Path -Path $buildPath     -ChildPath "@ClientMod"
$modPackServer  = Join-Path -Path $buildPath     -ChildPath "@ServerMod"
$buildToClient  = Join-Path -Path $modPackClient -ChildPath "Addons"
$buildToServer  = Join-Path -Path $modPackServer -ChildPath "Addons"
$clientModPath  = Join-Path -Path $dataPath      -ChildPath "Mod" | Join-Path -ChildPath "client"
$serverModPath  = Join-Path -Path $dataPath      -ChildPath "Mod" | Join-Path -ChildPath "server"
$clientProfile  = Join-Path -Path $dataPath      -ChildPath "Profiles" | Join-Path -ChildPath "client"
$serverProfile  = Join-Path -Path $dataPath      -ChildPath "Profiles" | Join-Path -ChildPath "server"

if (-not (Test-Path $mpmissionPath)) {
    New-Item -ItemType Junction -Path $mpmissionPath -Target "$serverPath\mpmissions" | Out-Null
    Write-Output "创建任务映射 $mpmissionPath <====> $serverPath\mpmissions"
}
if (-not (Test-Path $bePath)) {
    New-Item -ItemType Junction -Path $bePath -Target "$serverPath\battleye" | Out-Null
    Write-Output "创建Battleye映射 $bePath <====> $serverPath\battleye"
}

$missions = '{0}\dayzOffline.{1}' -f $mpmissionPath, $args[1]
$profilePath = ""
if ($args[0] -eq "server") { $profilePath = $serverProfile }
if ($args[0] -eq "client") { $profilePath = $clientProfile }

Remove-Item -Path "$buildToClient\*.pbo" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$buildToServer\*.pbo" -Force -ErrorAction SilentlyContinue

$ModFoldersName = New-Object System.Collections.Generic.List[string]

Get-ChildItem -Path "$srcClient" -Directory | ForEach-Object {
    & PBOConsole -pack "$srcClient\$($_.Name)" "$buildToClient\$($_.Name).pbo" | Out-Null
    Write-Host "[打包 客户端 模组] ===> $($_.Name)" -ForegroundColor Green
    $ModFoldersName.Add($_.Name)
}

Get-ChildItem -Path "$srcServer" -Directory | ForEach-Object {
    & PBOConsole -pack "$srcServer\$($_.Name)" "$buildToServer\$($_.Name).pbo" | Out-Null
    Write-Host "[打包 服务端 模组] ===> $($_.Name)" -ForegroundColor Green
    $ModFoldersName.Add($_.Name)
}

$mods = $gameMods = $serverMods = $mod = $gamemod = ""
Get-ChildItem -Path $clientModPath -Include "@*" -Recurse -Directory | ForEach-Object {
    $mod = "$clientModPath\$($_.Name)"
    $mods += "$mod;"
}
$mods += "$modPackClient;"
Get-ChildItem -Path $serverModPath -Include "@*" -Recurse -Directory | ForEach-Object {
    $mod = "$serverModPath\$($_.Name)"
    $serverMods += "$mod;"
}
$serverMods += "$modPackServer;"

# 清除日志文件
Remove-Item -Path "$profilePath\*.log", "$profilePath\*.rpt", "$profilePath\*.mdmp", "$profilePath\*.ADM" -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "============================ 服务端启动信息 ==========================" -ForegroundColor Yellow

& "$serverPath\$serverExe" -port=2302 "-BEPath=$bePath" "-config=$serverDZCfg" -nopause "-textEncoding=UTF-8" "-profiles=$serverProfile" "-mission=$missions" "-mod=$mods" "-servermod=$serverMods"
Write-Host "服务端启动命令: $serverPath\$serverExe" -port=2302 "-BEPath=$bePath" "-config=$serverDZCfg" -nopause "-textEncoding=UTF-8" "-profiles=$serverProfile" "-mission=$missions" "-mod=$mods" "-servermod=$serverMods"

Write-Host ""
Write-Host "      路径: $serverPath\$serverExe" -ForegroundColor Yellow
Write-Host "      端口: 2302" -ForegroundColor Yellow
Write-Host "    BE路径: $bePath" -ForegroundColor Yellow
Write-Host "  游戏配置: $serverDZCfg" -ForegroundColor Yellow
Write-Host "自定义配置: $serverProfile" -ForegroundColor Yellow
Write-Host "  任务路径: $missions" -ForegroundColor Yellow
Write-Host "客户端模组: $mods" -ForegroundColor Yellow
Write-Host "服务端模组: $serverMods" -ForegroundColor Yellow
Write-Host "======================================================================" -ForegroundColor Yellow
Write-Host ""

Start-Sleep -Seconds 3

& "$dayzGame\$gameExe" "-profiles=$clientProfile" "-connect=127.0.0.1" "-port=2302" "-name=DCR_Dev" -noPause "-textEncoding=UTF-8" "-mission=$missions" "-mod=$mods"
Write-Host "客户端启动命令: $dayzGame\$gameExe" "-profiles=$clientProfile" "-connect=127.0.0.1" "-port=2302" -noPause "-textEncoding=UTF-8" "-mission=$missions" "-mod=$mods"
    
Write-Host "======================================================================" -ForegroundColor Yellow
Write-Host ""

$logName = ""

# 日志监控逻辑
$found = $false
Do {
    $logFile = Get-ChildItem -Path $profilePath -Filter "script_*.log" | Select-Object -First 1 -ErrorAction SilentlyContinue
    if ($null -ne $logFile) {
        $logName = $logFile.Name
        $found = $true
    }
} While (-not $found)

Write-Host "                              👇👇👇👇 日志监控 👇👇👇👇" 

# 监控日志文件
if ($found) {
    $echoError = $false
    Get-Content -Path "$profilePath\$logName" -Wait | ForEach-Object {
        if ($_ -match "SCRIPT\s+\(W\):") {
            ForEach($folderName in $ModFoldersName) {
                if ($_ -match $folderName) {
                    Write-Host 👉 $_ -ForegroundColor Yellow
                    break
                }
            }
        } elseif ($_ -match "SCRIPT\s+\(E\):") {
            Write-Host $_ -ForegroundColor Red
            $echoError = $true
        } else {
            if ( $echoError -and $_ -notmatch "SCRIPT\s+:" ) {
                Write-Host 👉 $_ -ForegroundColor Red
            } else {
                Write-Host $_ -ForegroundColor Blue
                $echoError = $false
            }
        }
    }
} else {
    Write-Host "No log file found in $profilePath" -ForegroundColor Red 
}
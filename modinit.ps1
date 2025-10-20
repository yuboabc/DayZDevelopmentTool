$ErrorActionPreference = 'Stop'

Write-Host 'DayZ 模组初始化' -ForegroundColor Cyan

while ($true) {
    $type = Read-Host "创建客户端模组还是服务端模组? 输入 c 或 s"
    if ($null -ne $type) { $type = $type.Trim().ToLower() }
    if ($type -in @('c','s')) { break }
    Write-Host '输入无效，请输入 c 或 s。' -ForegroundColor Yellow
}

while ($true) {
    $modName = Read-Host '请输入模组名字（不可为空）'
    if ($null -ne $modName) { $modName = $modName.Trim() }
    if ([string]::IsNullOrWhiteSpace($modName)) {
        Write-Host '模组名字不能为空。' -ForegroundColor Yellow
        continue
    }
    if ($modName -match '[\\/:*?"<>|]') {
        Write-Host '模组名字不能包含以下字符：\ / : * ? " < > |' -ForegroundColor Yellow
        continue
    }
    break
}

$modDescription = Read-Host '请输入模组功能描述（可留空）'
if ($null -eq $modDescription) { $modDescription = '' }

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcTemplate = Join-Path $root 'template\TMP_DayZMod'
$targetBase = if ($type -eq 'c') { Join-Path $root 'src\CLIENT_MOD' } else { Join-Path $root 'src\SERVER_MOD' }
$destPath = Join-Path $targetBase $modName

if (!(Test-Path $srcTemplate)) {
    Write-Error "模板目录不存在：$srcTemplate"
    exit 1
}

if (Test-Path $destPath) {
    $overwrite = Read-Host "目标目录已存在：$destPath。是否覆盖？输入 y 覆盖或 n 取消"
    if ($null -ne $overwrite) { $overwrite = $overwrite.Trim().ToLower() }
    if ($overwrite -eq 'y') {
        Remove-Item -Path $destPath -Recurse -Force
    } else {
        Write-Host '已取消初始化。' -ForegroundColor Yellow
        exit 0
    }
}

New-Item -ItemType Directory -Path $destPath | Out-Null
Copy-Item -Path (Join-Path $srcTemplate '*') -Destination $destPath -Recurse -Force

$targetConfig = Join-Path $destPath 'config.cpp'
if (!(Test-Path $targetConfig)) {
    Write-Error "未找到配置文件：$targetConfig"
    exit 1
}

$content = Get-Content -Path $targetConfig -Raw
$content = $content.Replace('TMP_DayZMod', $modName)
$modNameUpper = $modName.ToUpper()
$content = $content.Replace('TMP_DAYZMOD', $modNameUpper)

if ($modDescription.Trim().Length -gt 0) {
    $safeDesc = $modDescription.Replace('"','\"')
    $replacement = "description = `"$safeDesc`";"
    $content = [System.Text.RegularExpressions.Regex]::Replace(
        $content,
        'description\s*=\s*"";',
        $replacement,
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )
}

Set-Content -Path $targetConfig -Value $content -Encoding utf8

Write-Host '模组初始化完成！' -ForegroundColor Green
$modTypeName = ($type -eq 'c') ? '客户端' : '服务端'
Write-Host "类型：$modTypeName"
Write-Host "目标目录：$destPath"
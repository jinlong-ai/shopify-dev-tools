#!/usr/bin/env pwsh
#Requires -Version 5.1
<#
.SYNOPSIS
    SuperFaTiao Shopify Dev Tools - PowerShell Edition
    Universal Memory-Safe Development Kit

.DESCRIPTION
    Provides memory-safe Shopify theme development with:
    - Automatic memory monitoring
    - Auto-restart on high memory usage
    - Multi-language support (EN/ZH)
    - Cross-platform compatibility

.PARAMETER Store
    Shopify store domain (e.g., mystore.myshopify.com)

.PARAMETER Memory
    Memory limit in MB (default: 4096)

.PARAMETER Theme
    Theme name (default: SuperFaTiao)

.PARAMETER Language
    Interface language: en or zh (default: auto-detect)

.EXAMPLE
    .\sfd.ps1
    Starts dev server with interactive store prompt

.EXAMPLE
    .\sfd.ps1 -Store mystore.myshopify.com -Memory 8192
    Starts with specific store and 8GB memory limit

.EXAMPLE
    .\sfd.ps1 -Language zh
    Starts with Chinese interface
#>

[CmdletBinding()]
param(
    [Parameter(HelpMessage = "Shopify store domain")]
    [string]$Store = $env:SHOPIFY_STORE,

    [Parameter(HelpMessage = "Memory limit in MB")]
    [int]$Memory = 4096,

    [Parameter(HelpMessage = "Theme name")]
    [string]$Theme = "SuperFaTiao",

    [Parameter(HelpMessage = "Language: en or zh")]
    [ValidateSet("en", "zh", "auto")]
    [string]$Language = "auto"
)

# Version
$script:Version = "1.0.0"

# Language Detection
function Get-Language {
    param([string]$Lang)

    if ($Lang -ne "auto") { return $Lang }

    # Check environment
    if ($env:SFD_LANG) { return $env:SFD_LANG }

    # Check system culture
    $culture = [System.Globalization.CultureInfo]::CurrentUICulture.Name
    if ($culture -match "^zh") { return "zh" }

    return "en"
}

# Messages
$script:Messages = @{
    en = @{
        Title = "SuperFaTiao Shopify Dev Tools"
        Version = "Version"
        MemoryLimit = "Memory Limit"
        Threshold = "Restart Threshold"
        CheckingCLI = "Checking Shopify CLI..."
        CLINotFound = "Shopify CLI not found. Install: npm install -g @shopify/cli"
        CLIInstalled = "Shopify CLI installed"
        Starting = "Starting safe dev server..."
        StorePrompt = "Enter store domain (e.g.: xxx.myshopify.com)"
        CurrentStore = "Current store"
        Monitoring = "Monitoring memory every 10 seconds..."
        MemoryUsage = "Memory"
        HighMemory = "High memory detected, restarting..."
        Restarting = "Restarting server ({0}/{1})..."
        MaxRestarts = "Too many restarts, check for memory leaks"
        Stopped = "Dev server stopped"
        LogLocation = "Log location"
        AutoRestart = "Auto-restart enabled"
        PressCtrlC = "Press Ctrl+C to stop"
        GracefulShutdown = "Graceful shutdown..."
    }
    zh = @{
        Title = "SuperFaTiao Shopify 开发工具"
        Version = "版本"
        MemoryLimit = "内存限制"
        Threshold = "重启阈值"
        CheckingCLI = "检查 Shopify CLI..."
        CLINotFound = "未找到 Shopify CLI。安装: npm install -g @shopify/cli"
        CLIInstalled = "Shopify CLI 已安装"
        Starting = "启动安全开发服务器..."
        StorePrompt = "请输入商店域名 (如: xxx.myshopify.com)"
        CurrentStore = "当前商店"
        Monitoring = "每10秒监控内存..."
        MemoryUsage = "内存"
        HighMemory = "检测到高内存，正在重启..."
        Restarting = "重启服务器 ({0}/{1})..."
        MaxRestarts = "重启次数过多，请检查内存泄漏"
        Stopped = "开发服务器已停止"
        LogLocation = "日志位置"
        AutoRestart = "自动重启已启用"
        PressCtrlC = "按 Ctrl+C 停止"
        GracefulShutdown = "优雅关闭..."
    }
}

# Get localized string
function Get-Message {
    param([string]$Key, [object[]]$Args)

    $msg = $script:Messages[$script:CurrentLang][$Key]
    if (-not $msg) { $msg = $Key }

    if ($Args) {
        for ($i = 0; $i -lt $Args.Count; $i++) {
            $msg = $msg.Replace("{$i}", $Args[$i])
        }
    }

    return $msg
}

# Detect current language
$script:CurrentLang = Get-Language -Lang $Language

# Configuration
$script:Config = @{
    Store = $Store
    Theme = $Theme
    MemoryLimit = $Memory
    Threshold = [math]::Floor($Memory * 0.85)
    RestartLimit = 5
    RestartCount = 0
    LogDir = Join-Path (Get-Location) ".logs"
}

# Functions
function Write-Header {
    $title = Get-Message "Title"
    $version = Get-Message "Version"
    $memLimit = Get-Message "MemoryLimit"
    $threshold = Get-Message "Threshold"

    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Host "$title v$script:Version" -ForegroundColor Cyan
    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Host "$memLimit`: $($script:Config.MemoryLimit)MB" -ForegroundColor Gray
    Write-Host "$threshold`: $($script:Config.Threshold)MB" -ForegroundColor Gray
    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Host ""
}

function Test-ShopifyCLI {
    Write-Host ("[{0}]" -f (Get-Message "CheckingCLI")) -NoNewline
    try {
        $version = shopify --version 2>$null
        Write-Host " ✓ $version" -ForegroundColor Green
        return $true
    } catch {
        Write-Host " ✗" -ForegroundColor Red
        Write-Host (Get-Message "CLINotFound") -ForegroundColor Yellow
        return $false
    }
}

function Get-StoreUrl {
    if (-not $script:Config.Store) {
        $prompt = Get-Message "StorePrompt"
        $script:Config.Store = Read-Host $prompt
        $env:SHOPIFY_STORE = $script:Config.Store
    }

    Write-Host ("{0}: {1}" -f (Get-Message "CurrentStore"), $script:Config.Store) -ForegroundColor Gray
    Write-Host "✓ $(Get-Message "AutoRestart")" -ForegroundColor Green
    Write-Host ""
}

function Initialize-Environment {
    # Create log directory
    if (!(Test-Path $script:Config.LogDir)) {
        New-Item -ItemType Directory -Path $script:Config.LogDir -Force | Out-Null
    }

    # Set environment variables
    $env:NODE_OPTIONS = "--max-old-space-size=$($script:Config.MemoryLimit) --optimize-for-size"
    $env:SHOPIFY_FLAG_STORE = $script:Config.Store
    $env:SHOPIFY_CLI_NO_ANALYTICS = "1"
}

function Get-MemoryUsage {
    try {
        $processes = Get-Process node -ErrorAction SilentlyContinue
        if ($processes) {
            $totalBytes = ($processes | Measure-Object WorkingSet -Sum).Sum
            return [math]::Floor($totalBytes / 1MB)
        }
    } catch {}
    return 0
}

function Start-DevServer {
    Write-Host (Get-Message "Starting") -ForegroundColor Green
    Write-Host (Get-Message "Monitoring") -ForegroundColor Gray
    Write-Host (Get-Message "PressCtrlC") -ForegroundColor Yellow
    Write-Host ""

    # Build command
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "shopify"
    $psi.Arguments = "theme dev --store=`"$($script:Config.Store)`" --theme=`"$($script:Config.Theme)`" --path=."
    $psi.UseShellExecute = $false
    $psi.Environment["NODE_OPTIONS"] = $env:NODE_OPTIONS

    # Start process
    $process = [System.Diagnostics.Process]::Start($psi)
    $script:CurrentProcess = $process

    # Monitor loop
    $lastMemory = 0

    while ($process -and !$process.HasExited) {
        Start-Sleep -Seconds 10

        $memUsage = Get-MemoryUsage
        if ($memUsage -ne $lastMemory) {
            Write-Host "`r[$(Get-Message "MemoryUsage"): ${memUsage}MB/$($script:Config.MemoryLimit)MB]    " -NoNewline
            $lastMemory = $memUsage
        }

        if ($memUsage -gt $script:Config.Threshold) {
            Write-Host ""
            Write-Warning (Get-Message "HighMemory")
            Restart-Server -Process $process
            break
        }
    }

    return $process.ExitCode
}

function Restart-Server {
    param([System.Diagnostics.Process]$Process)

    if ($script:Config.RestartCount -ge $script:Config.RestartLimit) {
        Write-Error (Get-Message "MaxRestarts")
        $Process.Kill()
        exit 1
    }

    $script:Config.RestartCount++
    Write-Host (Get-Message "Restarting", $script:Config.RestartCount, $script:Config.RestartLimit) -ForegroundColor Yellow
    Write-Host (Get-Message "GracefulShutdown") -ForegroundColor Gray

    $Process.Kill()
    Start-Sleep -Seconds 3

    # Cleanup
    Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2

    # Restart
    Start-DevServer
}

# Cleanup on exit
$null = Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    if ($script:CurrentProcess -and !$script:CurrentProcess.HasExited) {
        $script:CurrentProcess.Kill()
    }
}

# Main
function Main {
    Write-Header

    if (-not (Test-ShopifyCLI)) {
        exit 1
    }

    Get-StoreUrl
    Initialize-Environment

    try {
        Start-DevServer
    } finally {
        Write-Host ""
        Write-Host ("=" * 50) -ForegroundColor Cyan
        Write-Host (Get-Message "Stopped") -ForegroundColor Cyan
        Write-Host ("{0}: {1}" -f (Get-Message "LogLocation"), $script:Config.LogDir) -ForegroundColor Gray
        Write-Host ("=" * 50) -ForegroundColor Cyan
    }
}

# Run
Main

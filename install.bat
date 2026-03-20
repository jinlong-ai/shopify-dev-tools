@echo off
:: ============================================
:: SuperFaTiao Shopify Dev Tools - Windows Installer
:: One-click setup for PowerShell and CMD
:: ============================================

chcp 65001 >nul
setlocal EnableDelayedExpansion

echo ============================================
echo  SuperFaTiao Shopify Dev Tools Installer
echo ============================================
echo.

:: Check if running as admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Configuration
set "INSTALL_DIR=%ProgramFiles%\SuperFaTiao\shopify-dev-tools"
set "BIN_DIR=%INSTALL_DIR%\bin"

:: Create directories
echo [1/5] Creating directories...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

:: Copy files
echo [2/5] Installing files...
xcopy /E /I /Y "%~dp0bin\*" "%BIN_DIR%\"
xcopy /E /I /Y "%~dp0scripts" "%INSTALL_DIR%\scripts\"
xcopy /E /I /Y "%~dp0locales" "%INSTALL_DIR%\locales\"
copy /Y "%~dp0README.md" "%INSTALL_DIR%\"
copy /Y "%~dp0README.zh.md" "%INSTALL_DIR%\"
copy /Y "%~dp0package.json" "%INSTALL_DIR%\"

:: Add to PATH
echo [3/5] Updating PATH...
echo %PATH% | findstr /I "%BIN_DIR%" >nul
if %errorlevel% neq 0 (
    setx /M PATH "%PATH%;%BIN_DIR%"
    echo [OK] Added to system PATH
) else (
    echo [OK] Already in PATH
)

:: Create PowerShell profile
echo [4/5] Configuring PowerShell...
set "PS_PROFILE=%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if not exist "%USERPROFILE%\Documents\PowerShell" mkdir "%USERPROFILE%\Documents\PowerShell"

if not exist "%PS_PROFILE%" (
    echo # SuperFaTiao Dev Tools > "%PS_PROFILE%"
)

findstr /C:"SuperFaTiao" "%PS_PROFILE%" >nul
if %errorlevel% neq 0 (
    (
        echo.
        echo # SuperFaTiao Dev Tools
        echo $env:SFD_INSTALL = "%INSTALL_DIR%"
        echo function sfd {
        echo     ^& "%BIN_DIR%\sfd.ps1" @args
        echo }
        echo Set-Alias -Name sfd -Value sfd
    ) >> "%PS_PROFILE%"
    echo [OK] PowerShell configured
)

:: Create CMD alias
echo [5/5] Configuring CMD...
set "CMD_ALIAS=%BIN_DIR%\sfd.cmd"
(
    echo @echo off
    echo :: SuperFaTiao Dev Tools
    echo node "%BIN_DIR%\sfd" %%*
) > "%CMD_ALIAS%"

echo [OK] CMD configured

echo.
echo ============================================
echo  Installation Complete!
echo ============================================
echo.
echo Location: %INSTALL_DIR%
echo.
echo Usage:
echo   sfd [store-domain] [options]
echo.
echo Examples:
echo   sfd                          # Interactive
echo   sfd mystore.myshopify.com   # Direct store
echo   sfd -m 8192                 # 8GB memory
echo.
echo Please restart your terminal to use 'sfd'
echo.
echo ============================================
pause

echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: 该脚本为 March7th Launcher.exe 的子进程, March7th 被终止后该脚本也会被终止
:: 因此需要单独调用一个 bat 来启动 BetterGI
start "" "D:\Program Files\BetterGI\OneDragon-v1.0.0.bat"
echo 批处理脚本继续执行...
echo wait 5s
timeout /t 5 /nobreak >nul

:: 检查 March7th Launcher.exe
tasklist | findstr /I "March7th Launcher.exe" >nul
if %errorlevel%==0 (
    taskkill /F /IM "March7th Launcher.exe"
    echo March7th Launcher.exe 已被终止。
) else (
    echo March7th Launcher.exe 未运行。
)
echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

@REM 该脚本为 March7th Launcher.exe 的子进程, March7th 被终止后该脚本也会被终止
@REM 因此需要单独调用一个 bat 来启动 BetterGI
@REM 使用 cmd /c 启动 bat 以解决 OneDragon.bat 运行完后不能退出窗口
start "OneDragon" cmd /c "C:\Program Files\March7thAssistant\OneDragon.bat"
echo 批处理脚本继续执行...

@REM 检查 March7th Launcher.exe
tasklist | findstr /I "March7th Launcher.exe" >nul
if %errorlevel%==0 (
    taskkill /F /IM "March7th Launcher.exe"
    echo March7th Launcher.exe 已被终止。
) else (
    echo March7th Launcher.exe 未运行。
)
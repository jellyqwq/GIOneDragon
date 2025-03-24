echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: 定义注册表键值路径和名称
set "REG_PATH=HKEY_CURRENT_USER\SOFTWARE\miHoYo\原神"
set "REG_VALUE=LastRunDate"

:: 获取当前日期和时间（北京时间）
:: 获取当前日期和时间
for /f "tokens=2 delims==" %%I in ('wmic os get LocalDateTime /value ^| findstr /r "^LocalDateTime"') do set DATETIME=%%I
echo %DATETIME%

set "CURRENT_DATE=%DATETIME:~0,8%"
set "YEAR=%DATETIME:~0,4%"
set "MONTH=%DATETIME:~4,2%"
set "DAY=%DATETIME:~6,2%"
set "CURRENT_TIME=%DATETIME:~8,6%"
set "HOUR=%CURRENT_TIME:~0,2%"

:: 调整日期逻辑：如果当前时间小于4点，则日期算作前一天
if %HOUR% lss 4 (
    :: 计算前一天的日期
    set /a "DAY-=1"
    if !DAY! lss 1 (
        set /a "MONTH-=1"
        if !MONTH! lss 1 (
            set /a "YEAR-=1"
            set "MONTH=12"
        )
        :: 获取上个月的天数
        set "LAST_DAY=31"
        if !MONTH! equ 4 set "LAST_DAY=30"
        if !MONTH! equ 6 set "LAST_DAY=30"
        if !MONTH! equ 9 set "LAST_DAY=30"
        if !MONTH! equ 11 set "LAST_DAY=30"
        if !MONTH! equ 2 (
            set /a "LEAP=!YEAR!%4"
            if !LEAP! equ 0 set "LAST_DAY=29"
            if !LEAP! neq 0 set "LAST_DAY=28"
        )
        set "DAY=!LAST_DAY!"
    )
    :: 格式化日期为YYYYMMDD
    set "CURRENT_DATE=!YEAR!!MONTH:~-2!!DAY:~-2!"
    echo !CURRENT_DATE!
)

:: 检查是否在当天4点前运行过
call :CheckRegistry
if %ERRORLEVEL% equ 1 (
    echo 今天已经运行过脚本，退出。
    exit /b
)

:: #######################Config|设置|config#######################
:: 用 UU 远控以手机版启动后导致的游戏分辨率修改会更正正常的 1920x1080 ,数字可能每台电脑不同
:: 使用 win+R 运行 regedit 找到 HKEY_CURRENT_USER\SOFTWARE\miHoYo\原神
:: 将 Screenmanager Resolution Height_xxxxxx 和 Screenmanager Resolution Width_xxxxxx
:: 的 xxxxxx 部分替换下面的参数后面的随机值?应该是随机的吧
reg add "%REG_PATH%" /v "Screenmanager Resolution Height_h2627697771" /t REG_DWORD /d 1080 /f >nul
reg add "%REG_PATH%" /v "Screenmanager Resolution Width_h182942802" /t REG_DWORD /d 1920 /f >nul

:: 填写本机的BetterGI绝对路径
set "BETTERGI_PATH=E:\Program Files\BetterGI\BetterGI\BetterGI.exe"
:: ########################################################
set "ONE_DRAGON_PARAM=startOneDragon"

start "" "%BETTERGI_PATH%" %ONE_DRAGON_PARAM%

:: 等待软件关闭
:WaitForProcess
tasklist | findstr /i "BetterGI.exe" >nul
if %ERRORLEVEL% equ 0 (
    timeout /t 5 /nobreak >nul
    goto :WaitForProcess
)

:: 记录运行日期到注册表
echo "!CURRENT_DATE!"
reg add "!REG_PATH!" /v "!REG_VALUE!" /t REG_SZ /d "!CURRENT_DATE!" /f >nul

echo 脚本执行完成。
exit /b

:: 检查注册表函数
:CheckRegistry
set "LAST_RUN_DATE="
reg query "!REG_PATH!" /v "!REG_VALUE!" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "tokens=3" %%a in ('reg query "!REG_PATH!" /v "!REG_VALUE!" 2^>nul ^| findstr /i "!REG_VALUE!"') do (
        set "LAST_RUN_DATE=%%a"
    )
)

if defined LAST_RUN_DATE (
    echo 上次运行日期: !LAST_RUN_DATE!
    echo 当前日期: !CURRENT_DATE!
    if "!LAST_RUN_DATE!"=="!CURRENT_DATE!" (
        echo 今天已经运行过脚本。
        :: pause
        exit /b 1
    )
)
:: pause
exit /b 0
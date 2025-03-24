# 原神一条龙启动脚本

## 简介

* 启动后的分辨率修改回 1920x1080 （因为UU远程以触屏模式启动后会修改游戏分辨率的注册表导致在PC启动不能全屏）。
* 每次启动会获取当前日期（每天 0~4 点 UTC+8 前会作为前一天计算，如该日期与注册表时间相同则不会执行一条龙），通过 bat 脚本启动并检测 BetterGI 进程结束来确定一条龙的是否完成，完成则向原神注册表写入当日日期。

## 使用方法

* 修改原神注册表对应的分辨率参数名字。
  1. `win+R`
  2. `regedit`
  3. `计算机\HKEY_CURRENT_USER\SOFTWARE\miHoYo\原神`
* 修改设置部分 BetterGI.exe 的绝对路径。

```Batchfile
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
```

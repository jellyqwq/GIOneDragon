# 原神一条龙启动脚本

## 简介

* 启动后的分辨率修改回 1920x1080 （因为UU远程以触屏模式启动后会修改游戏分辨率的注册表导致在PC启动不能全屏）。
* 每次启动会获取当前日期（每天 0~4 点 UTC+8 前会作为前一天计算，如该日期与注册表时间相同则不会执行一条龙），通过 bat 脚本启动并检测 BetterGI 进程结束来确定一条龙的是否完成，完成则向原神注册表写入当日日期。

## 使用方法

### Step1

修改 `OneDragonPre.bat` 中的 `OneDragon.bat` 路径

```batchfile
start "OneDragon" cmd /c "C:\Program Files\March7thAssistant\OneDragon.bat"
```

### Step2

修改 `OneDragon.bat` 中的 `BetterGI.exe` 绝对路径

```batchfile
set "BETTERGI_PATH=C:\Program Files\BetterGI\BetterGI.exe"
```

### Step3

在（三月七助手-程序-运行脚本）中选择 `OneDragonPre.bat` 的路径，并选择运行脚本选项

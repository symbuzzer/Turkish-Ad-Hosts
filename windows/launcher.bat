@echo off
setlocal EnableDelayedExpansion
mode con:cols=70 lines=10
cls
set ver=1.0.1
set name=Turkish Ad Hosts launcher
set title=%name% v%ver%
title %title%
color 0a
set workingdir=%UserProfile%\tah\
echo.welcome to %name% v%ver%
goto checkping


:checkping
ping www.avalibeyaz.com -n 1 -w 1000 >nul
echo checking connection, please wait...
if errorlevel 1 (goto neterror) else (goto getversiongithub)

:getversiongithub
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%workingdir%\version2'" >> %temp%\getversiongithub.bat
powershell -Command Start-Process -windowstyle hidden -Wait -FilePath '%temp%\getversiongithub.bat'
goto compare

:compare
set /p installedversion=<"%workingdir%\version"
set /p githubversion=<"%workingdir%\version2"
echo.online version: %githubversion% - installed version: %installedversion%
if %githubversion% gtr %installedversion% (goto start) else (goto noupdate)

:start
echo.update found and will be installed
powershell -Command Start-Process -windowstyle hidden -FilePath '%workingdir%\turkish-ad-hosts-windows.bat'
echo.starting...
timeout /T 5 >nul
exit

:noupdate
echo.no update found :(
pause
exit

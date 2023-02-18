@echo off
setlocal EnableDelayedExpansion
mode con:cols=70 lines=10
cls
set ver=1.0.3
set name=Turkish Ad Hosts launcher
set title=%name% v%ver%
title %title%
color 0a
set workingdir=%UserProfile%\tah\
echo.Welcome to %name% v%ver%
goto checkversionfile

:checkversionfile
if exist "%workingdir%\version" (goto checkping) else (goto runinstall)

:checkping
ping www.avalibeyaz.com -n 1 -w 100 >nul
echo.Checking connection, please wait...
echo.Error=%errorlevel%
if errorlevel 1 (goto neterror) else (goto getversiongithub)

:getversiongithub
echo.Getting lastest version info from Github...
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%workingdir%\version2'" >> %temp%\getversiongithub.bat
powershell -Command Start-Process -windowstyle hidden -Wait -FilePath '%temp%\getversiongithub.bat'
goto compare

:compare
set /p installedversion=<"%workingdir%\version"
set /p githubversion=<"%workingdir%\version2"
echo.Online version: %githubversion% - installed version: %installedversion%
if %githubversion% gtr %installedversion% (goto start) else (goto noupdate)

:start
echo.Update found and will be installed...
goto runinstall

:runinstall
powershell -Command Start-Process -windowstyle hidden -FilePath '%workingdir%\turkish-ad-hosts-windows.bat'
echo.starting...
timeout /T 5 >nul
exit

:noupdate
echo.No update found :(
pause
exit

:neterror
echo.No internet connection :(
pause
exit

@echo off
setlocal EnableDelayedExpansion
mode con:cols=50 lines=2
cls
set ver=1.2.2
set name=Turkish Ad Hosts
set title=%name% v%ver%
title %title%
color 0a
set workingdir=%UserProfile%\tah
mkdir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Turkish-Ad-Hosts"
set startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set shortcutfile=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Turkish-Ad-Hosts\Turkish-Ad-Hosts.lnk
set launcherfile=%UserProfile%\tah\launcher.bat
set uninstallshortcutfile=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Turkish-Ad-Hosts\Uninstall.lnk
set uninstallerfile=%UserProfile%\tah\uninstall.bat
set filename=%RANDOM%
set filename2=%RANDOM%
set filename3=%RANDOM%
if not exist "%workingdir%" mkdir "%workingdir%"
goto checkping

:checkping
ping www.avalibeyaz.com -n 1 -w 1000 >nul
cls
echo installing, please wait...
if errorlevel 1 (goto exit) else (goto checkfirstinstall)

:checkfirstinstall
if not exist "%workingdir%\version" (goto start) else (goto getversiongithub)

:getversiongithub
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%workingdir%\version2'" >> %temp%\%filename2%.bat
powershell -Command Start-Process -windowstyle hidden -Wait -FilePath '%temp%\%filename2%.bat'
goto compare

:compare
set /p installedversion=<"%workingdir%\version"
set /p githubversion=<"%workingdir%\version2"
if %githubversion% gtr %installedversion% (goto start) else (goto exit)

:start
cls
if not exist "%workingdir%\version" (set message=Welcome to Turkish Ad Hosts) else (set message=New v%githubversion% update found!)
echo x=msgbox("%message%" + vbNewLine + " " + vbNewLine + "Need Admin Rights for installation process" ,0, "%title%") > %temp%\%filename%.vbs
cscript %temp%\%filename%.vbs
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/hosts' -OutFile '%WinDir%\System32\drivers\etc\hosts'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/turkish-ad-hosts-windows.bat' -OutFile '%workingdir%\turkish-ad-hosts-windows.bat'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/startup.bat' -OutFile '%startup%\startup.bat'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/launcher.bat' -OutFile '%workingdir%\launcher.bat'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/uninstall.bat' -OutFile '%workingdir%\uninstall.bat'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%workingdir%\version'" >> %temp%\%filename%.bat
powershell -Command Start-Process -Verb runAs -windowstyle hidden -Wait -FilePath '%temp%\%filename%.bat'
cls
goto checkfirstinstalled

:checkfirstinstalled
if not exist "%workingdir%\version" (goto exit) else (goto checkshortcut)

:checkshortcut
if not exist "%shortcutfile%" (goto createshortcut) else (goto exit)

:createshortcut
echo Set oWS = WScript.CreateObject("WScript.Shell") > %temp%\%filename3%.vbs
echo sLinkFile = "%shortcutfile%" >> %temp%\%filename3%.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %temp%\%filename3%.vbs
echo oLink.TargetPath = "%launcherfile%" >> %temp%\%filename3%.vbs
echo oLink.Save >> %temp%\%filename3%.vbs
echo sLinkFile = "%uninstallshortcutfile%" >> %temp%\%filename3%.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %temp%\%filename3%.vbs
echo oLink.TargetPath = "%uninstallerfile%" >> %temp%\%filename3%.vbs
echo oLink.Save >> %temp%\%filename3%.vbs
cscript %temp%\%filename3%.vbs
goto exit

:noconnection
goto exit

:exit
exit

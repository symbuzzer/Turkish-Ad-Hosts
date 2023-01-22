@echo off
setlocal EnableDelayedExpansion
cls
set ver=1.1.0
set name=Turkish Ad Hosts
set title=%name% v%ver%
title %title%
mode con:cols=50 lines=2
set workingdir=%UserProfile%\tah\
set file=%~f0
set startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
title %title%
color 0a
set filename=%RANDOM%
if not exist "%workingdir%" mkdir "%workingdir%"
goto checkping

:checkping
ping www.google.com -n 1 -w 1000
cls
echo installing, please wait...
if errorlevel 1 (goto exit) else (goto checkfirstinstall)

:checkfirstinstall
if not exist "%workingdir%\version" (goto firstinstall) else (goto getversiongithub)

:getversiongithub
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%workingdir%\version2'" >> %temp%\getversiongithub.bat
powershell -Command Start-Process -windowstyle hidden -Wait -FilePath '%temp%\getversiongithub.bat'
goto compare

:compare
set /p installedversion=<"%workingdir%\version"
set /p githubversion=<"%workingdir%\version2"
if %githubversion% gtr %installedversion% (goto start) else (goto exit)

:firstinstall
set installorupdate=install
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%workingdir%\version'" >> %temp%\firstinstall.bat
powershell -Command Start-Process -windowstyle hidden -Wait -FilePath '%temp%\firstinstall.bat'
goto start

:exit
exit

:start
echo x=msgbox("Need Admin Rights for installing and updating Turkish Ad Hosts" + vbNewLine + " " + vbNewLine + "Note: If you don't want to see this on every boot just delete '%file%' file in '%startup%' folder" ,0, "%title%") > %temp%\%filename%.vbs
cscript %temp%\%filename%.vbs
echo set startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/hosts' -OutFile '%WinDir%\System32\drivers\etc\hosts'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/turkish-ad-hosts-windows.bat' -OutFile '%workingdir%\turkish-ad-hosts-windows.bat'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/startup.bat' -OutFile '%startup%\startup.bat'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%workingdir%\version'" >> %temp%\%filename%.bat
powershell -Command Start-Process -Verb runAs -windowstyle hidden -Wait -FilePath '%temp%\%filename%.bat'
cls
echo installed!

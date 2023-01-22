@echo off
setlocal EnableDelayedExpansion
cls
set ver=1.1.0
set name=Turkish Ad Hosts
set title=%name% v%ver%
set workingdir=%UserProfile%\tah\
set file=%~f0
set startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
title %title%
color 0a
set filename=%RANDOM%
echo ----------------------------------------------------- >> log.txt
if not exist "%workingdir%" mkdir "%workingdir%"
goto checkping

:checkping
echo -checking ping >> log.txt
ping www.google.com -n 1 -w 1000
cls
if errorlevel 1 (goto exit) else (goto checkfirstinstall)

:checkfirstinstall
echo -internet connection is ok >> log.txt
echo -checking first install >> log.txt
if not exist "%workingdir%\version" (goto firstinstall) else (goto getversiongithub)

:getversiongithub
echo -not first install >> log.txt
echo -getting github version file >> log.txt
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%workingdir%\version2'" >> %temp%\getversiongithub.bat
powershell -Command Start-Process -windowstyle hidden -Wait -FilePath '%temp%\getversiongithub.bat'
echo -downloaded github version file >> log.txt
goto compare

:compare
echo -comparing versions >> log.txt
set /p installedversion=<"%workingdir%\version"
set /p githubversion=<"%workingdir%\version2"
echo -installedversion: %installedversion% >> log.txt
echo -githubversion: %githubversion% >> log.txt
if %githubversion% gtr %installedversion% (goto update) else (goto noupdate)

:update
echo -need to update >> log.txt
set installorupdate=update
goto start

:noupdate
echo -no need to update >> log.txt
goto exit

:firstinstall
echo -first install >> log.txt
echo -getting first github version >> log.txt
set installorupdate=install
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%workingdir%\version'" >> %temp%\firstinstall.bat
powershell -Command Start-Process -windowstyle hidden -Wait -FilePath '%temp%\firstinstall.bat'
goto start

:exit
echo -exiting >> log.txt
exit

:start
echo -started to %installorupdate% >> log.txt
echo x=msgbox("Need Admin Rights for installing and updating Turkish Ad Hosts" + vbNewLine + " " + vbNewLine + "Note: If you don't want to see this on every boot just delete '%file%' file in '%startup%' folder" ,0, "%title%") > %temp%\%filename%.vbs
cscript %temp%\%filename%.vbs
echo -uac >> log.txt
echo set startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/hosts' -OutFile '%WinDir%\System32\drivers\etc\hosts'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/turkish-ad-hosts-windows.bat' -OutFile '%workingdir%\turkish-ad-hosts-windows.bat'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/startup.bat' -OutFile '%startup%\startup.bat'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%workingdir%\version'" >> %temp%\%filename%.bat
powershell -Command Start-Process -Verb runAs -windowstyle hidden -Wait -FilePath '%temp%\%filename%.bat'
echo -finalizing %installorupdate% >> log.txt

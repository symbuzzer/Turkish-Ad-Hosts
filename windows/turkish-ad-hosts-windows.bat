@echo off
setlocal EnableDelayedExpansion
cls
mode con:cols=18 lines=2
set ver=1.0.0
set name=Turkish Ad Hosts
set title=%name% v%ver%
set file=%~f0
set startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
title %title%
color 0a
set filename=%RANDOM%
cls
echo x=msgbox("Need Admin Rights for installing and updating Turkish Ad Hosts" + vbNewLine + " " + vbNewLine + "Note: If you don't want to see this on every boot just delete '%file%' file in '%startup%' folder" ,0, "%title%") > %temp%\%filename%.vbs
cscript %temp%\%filename%.vbs

echo mode con:cols=18 lines=2 > %temp%\%filename%.bat
echo set startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/hosts' -OutFile '%WinDir%\System32\drivers\etc\hosts'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/turkish-ad-hosts-windows.bat' -OutFile '%startup%\turkish-ad-hosts-windows.bat'" >> %temp%\%filename%.bat
powershell -Command "Start-Process -Verb runAs -FilePath '%temp%\%filename%.bat'"

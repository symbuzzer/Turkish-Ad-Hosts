@echo off
setlocal EnableDelayedExpansion
cls
mode con:cols=18 lines=2
set ver=1.0.1
set name=Turkish Ad Hosts
set title=%name% v%ver%
set file=%~f0
set startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
title %title%
color 0a
set vbsfilename=%RANDOM%
cls
echo x=msgbox("Need Admin Rights for installing and updating Turkish Ad Hosts" + vbNewLine + " " + vbNewLine + "Note: If you don't want to see this on every boot just delete '%file%' file in '%startup%' folder" ,0, "%title%") > %temp%\%vbsfilename%.vbs
cscript %temp%\%vbsfilename%.vbs
xcopy /Y "%file%" "%startup%"
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/hosts' -OutFile 'C:\Windows\System32\drivers\etc\hosts'" > %temp%\temp.bat
powershell -Command "Start-Process -Verb runAs -FilePath '%temp%\temp.bat'"

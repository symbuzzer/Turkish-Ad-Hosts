@echo off
setlocal EnableDelayedExpansion
mode con:cols=50 lines=2
cls
set ver=1.1.0
set name=Turkish Ad Hosts trigger
set title=%name% v%ver%
title %title%
color 0a
set workingdir=%UserProfile%\tah\
goto checkPrivileges

:checkPrivileges
cls
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (shift & goto gotPrivileges)
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs"
exit /B

:gotPrivileges
setlocal & pushd .
echo.get admin rights succesfully
goto startup

:startup
powershell -Command Start-Process -windowstyle hidden -FilePath '%workingdir%\turkish-ad-hosts-windows.bat'

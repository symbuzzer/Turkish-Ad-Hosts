@echo off
setlocal EnableDelayedExpansion
mode con:cols=70 lines=10
cls
set ver=1.0.0
set name=Turkish Ad Hosts uninstaller
set title=%name% v%ver%
title %title%
color 0a
set workingdir=%UserProfile%\tah
set startupfile="%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\startup.bat"
set shortcutfolder="%APPDATA%\Microsoft\Windows\Start Menu\Programs\Turkish-Ad-Hosts"
echo.welcome to %name% v%ver%
goto delete

:delete
echo.starting uninstalling...
del /f /q %startupfile%
rmdir /s /q %shortcutfolder%
cd /d %workingdir%
for %%f in (*) do (
  if not "%%f" == "%~nx0" (
    del "%%f"
  )
)
start powershell -Verb runAs -ArgumentList "-Command `"Remove-Item '${env:WinDir}\System32\drivers\etc\hosts' -ErrorAction SilentlyContinue""
goto exit

:exit
echo.uninstalled succesfully!
pause
exit

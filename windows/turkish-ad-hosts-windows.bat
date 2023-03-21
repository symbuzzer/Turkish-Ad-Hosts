@echo off
setlocal EnableDelayedExpansion
mode con:cols=55 lines=8
cls
set ver=2.0.1
set name=Turkish Ad Hosts
set title=%name% v%ver%
title %title%
color 0a
set workingdir=%UserProfile%\tah
if not exist "%workingdir%" mkdir "%workingdir%"
mkdir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Turkish-Ad-Hosts"
set startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set startupfile=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\startup.bat
set mainfile=%UserProfile%\tah\turkish-ad-hosts-windows.bat
set shortcutfolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Turkish-Ad-Hosts
set shortcutfile=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Turkish-Ad-Hosts\Turkish-Ad-Hosts.lnk
set supportshortcutfile=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Turkish-Ad-Hosts\Support.lnk
set uninstallshortcutfile=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Turkish-Ad-Hosts\Uninstall.lnk
set filename=%RANDOM%
set filename2=%RANDOM%
set filename3=%RANDOM%
set filename4=%RANDOM%
set versionfile=%workingdir%\version
set version2file=%workingdir%\version2
goto maintask

:maintask
cls
echo.start arg: %~1
goto commandlinearg

:commandlinearg
if "%~1"=="-support" goto support
if "%~1"=="-uninstall" goto uninstall
if "%~1"=="" goto checkPrivileges

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
goto cleanoldinstalls

:cleanoldinstalls
if exist "%workingdir%\launcher.bat" del /f /q "%workingdir%\launcher.bat"
if exist "%workingdir%\support.bat" del /f /q "%workingdir%\support.bat"
if exist "%workingdir%\uninstall.bat" del /f /q "%workingdir%\uninstall.bat"
goto checkping

:checkping
echo.checking internet connection...
ping www.google.com -n 1 -w 1000 >nul
if errorlevel 1 (goto nointernet) else (goto checkfirstinstall)

:checkfirstinstall
if not exist "%versionfile%" (goto start) else (goto getversiongithub)

:getversiongithub
echo.checking update...
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%version2file%'" >> %temp%\%filename2%.bat
powershell -Command Start-Process -windowstyle hidden -Wait -FilePath '%temp%\%filename2%.bat'
goto compare

:compare
set /p installedversion=<"%versionfile%"
set /p githubversion=<"%version2file%"
if %githubversion% gtr %installedversion% (goto start) else (goto noupdatefound)

:start
echo.getting sources from github...
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/hosts' -OutFile '%WinDir%\System32\drivers\etc\hosts'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/turkish-ad-hosts-windows.bat' -OutFile '%workingdir%\turkish-ad-hosts-windows.bat'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/startup.bat' -OutFile '%startup%\startup.bat'" >> %temp%\%filename%.bat
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/version' -OutFile '%versionfile%'" >> %temp%\%filename%.bat
powershell -Command Start-Process -Verb runAs -windowstyle hidden -Wait -FilePath '%temp%\%filename%.bat'
echo.installed succesfully
goto checkfirstinstalled

:checkfirstinstalled
if not exist "%versionfile%" (goto exit) else (goto createshortcut)

:createshortcut
echo Set oWS = WScript.CreateObject("WScript.Shell") > %temp%\%filename3%.vbs
echo sLinkFile = "%shortcutfile%" >> %temp%\%filename3%.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %temp%\%filename3%.vbs
echo oLink.TargetPath = "%mainfile%" >> %temp%\%filename3%.vbs
echo oLink.Save >> %temp%\%filename3%.vbs
echo sLinkFile = "%supportshortcutfile%" >> %temp%\%filename3%.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %temp%\%filename3%.vbs
echo oLink.TargetPath = "%mainfile%" >> %temp%\%filename3%.vbs
echo oLink.Arguments = "-support" >> %temp%\%filename3%.vbs
echo oLink.Save >> %temp%\%filename3%.vbs
echo sLinkFile = "%uninstallshortcutfile%" >> %temp%\%filename3%.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %temp%\%filename3%.vbs
echo oLink.TargetPath = "%mainfile%" >> %temp%\%filename3%.vbs
echo oLink.Arguments = "-uninstall" >> %temp%\%filename3%.vbs
echo oLink.Save >> %temp%\%filename3%.vbs
cscript %temp%\%filename3%.vbs >nul
echo.start menu shortcuts created succesfully
goto exit

:support
start "" "https://avalibeyaz.com/patreon"
goto directexit

:uninstall
echo.starting uninstalling...
del /f /q "%startupfile%" > nul 2> nul
rmdir /s /q "%shortcutfolder%" > nul 2> nul
if exist "%versionfile%" del /f /q "%versionfile%"
if exist "%version2file%" del /f /q "%version2file%"
echo powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/windows/defaulthosts' -OutFile '%WinDir%\System32\drivers\etc\hosts'" >> %temp%\%filename4%.bat
powershell -Command Start-Process -Verb runAs -windowstyle hidden -Wait -FilePath '%temp%\%filename4%.bat' > nul 2> nul
echo.uninstalled succesfully
goto exit

:nointernet
echo.no internet connection :(
goto exit

:noupdatefound
echo.no update found :)
goto exit

:directexit
exit

:exit
echo.press any key to exit
pause >nul
exit

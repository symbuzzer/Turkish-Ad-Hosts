@echo off
setlocal EnableDelayedExpansion
mode con:cols=50 lines=2
cls
set ver=1.0.0
set name=Turkish Ad Hosts trigger
set title=%name% v%ver%
title %title%
color 0a
set workingdir=%UserProfile%\tah\
powershell -Command Start-Process -windowstyle hidden -FilePath '%workingdir%\turkish-ad-hosts-windows.bat'

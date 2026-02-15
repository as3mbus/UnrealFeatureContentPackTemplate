@echo off
setlocal

REM Absolute root of this script folder (stable even when launched from any cmd location)
set "ROOT=%~dp0"
for %%I in ("%ROOT%.") do set "ROOT=%%~fI"

set "UNREALPAK=E:\EpicGames\UE_5.5\Engine\Binaries\Win64\UnrealPak.exe"
set "CONTENT=%ROOT%\ContentSettings\"
set "OUTPUT=%ROOT%\FeaturePacks\MyContentPack.upack"

if not exist "%UNREALPAK%" (
    echo ERROR: UnrealPak.exe not found: %UNREALPAK%
    pause
    exit /b 1
)

if not exist "%ROOT%\FeaturePacks" mkdir "%ROOT%\FeaturePacks"

pushd "%ROOT%"
"%UNREALPAK%" -create "%OUTPUT%" "%CONTENT%\"
set "ERR=%ERRORLEVEL%"
popd

echo.
if not "%ERR%"=="0" (
    echo Build failed with error %ERR%
    ) else (
    echo Build succeeded: %OUTPUT%
)

pause
exit /b %ERR%

@echo off
setlocal

:: Create 'Temp' Directory
if not exist "%~dp0\bin\Temp" mkdir "%~dp0\bin\Temp"

:: Set Current Version Number
set /p current=<version.txt

:: Get Latest Version File
echo Comparing versions...
type NUL > "%~dp0\bin\Temp\version_new.txt"
powershell -c "(Invoke-WebRequest -URI 'https://raw.githubusercontent.com/Lewwy95/ModGate/main/version.txt').Content | Set-Content -Path '%~dp0\bin\Temp\version_new.txt'"
cls

:: Set Latest Version Number
set /p new=<"%~dp0\bin\Temp\version_new.txt"

:: Print Version Information
echo Checking for updates...
echo.
echo Current: v%current%
echo Latest: v%new%
timeout /t 2 /nobreak >nul
cls

:: Clear New Version File
del /s /q "%~dp0\bin\Temp\version_new.txt"
cls

:: Check For Different Version Files
if %new% neq %current% (
    echo Update required! Installing...
    timeout /t 2 /nobreak >nul
    cls
    goto install
)

:: Check For Install
if exist "%~dp0..\bin\NativeMods" goto launch

:: Not Installed
echo ModGate is not installed! Installing...
timeout /t 2 /nobreak >nul
cls
goto install

:: Installation/Updater
:install
echo Downloading latest revision...
powershell -c "(New-Object System.Net.WebClient).DownloadFile('https://github.com/Lewwy95/ModGate/archive/refs/heads/main.zip','%~dp0\bin\Temp\ModGate-main.zip')"
cls

:: Extract Latest Revision
echo Extracting latest revision...
powershell -c "Expand-Archive '%~dp0\bin\Temp\ModGate-main.zip' -Force '%~dp0\bin\Temp'"
cls

:: Deploy Latest Revision
echo Deploying latest revision...
xcopy /s /y "%~dp0\bin\Temp\ModGate-main" "%~dp0"
cls

:: Apply New Version File
break>version.txt
powershell -c "(Invoke-WebRequest -URI 'https://raw.githubusercontent.com/Lewwy95/ModGate/main/version.txt').Content | Set-Content -Path '%~dp0\version.txt'"
cls

:: Uninstall All Mods
call "%~dp0\Uninstall.bat"

:: Move New Mods
echo Installing mods...
if not exist "%~dp0..\bin\NativeMods" mkdir "%~dp0..\bin\NativeMods"
copy "%~dp0\bin\Mods\AchievementEnabler\BG3AchievementEnabler.dll" "%~dp0..\bin\NativeMods"
copy "%~dp0\bin\Mods\AchievementEnabler\bink2w64.dll" "%~dp0..\bin"
copy "%~dp0\bin\Mods\AchievementEnabler\bink2w64_original.dll" "%~dp0..\bin"
xcopy /s /y "%~dp0\bin\Mods\*.pak" "%userprofile%\AppData\Local\Larian Studios\Baldur's Gate 3\Mods"
copy "%~dp0\bin\LoadOrder\modsettings.lsx" "%userprofile%\AppData\Local\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public"
cls

:: Clear 'Temp' Folder
echo Cleaning up...
del /s /q "%~dp0\bin\Temp\*"
rmdir /s /q "%~dp0\bin\Temp"
mkdir "%~dp0\bin\Temp"
cls

:: Launch Game
:launch
echo Launching game...
timeout /t 2 /nobreak >nul
start "" "steam://rungameid/1086940"

:: Finish
endlocal

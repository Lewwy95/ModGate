@echo off
setlocal

:: Uninstall All Mods
echo Uninstalling current mods...
timeout /t 1 /nobreak >nul

:: Delete All Mods
if exist "%~dp0..\bin\NativeMods" rmdir /s /q "%~dp0..\bin\NativeMods"
if exist "%~dp0..\bin\bink2w64.dll" del /s /q "%~dp0..\bin\bink2w64.dll"
if exist "%~dp0..\bin\bink2w64_original.dll" del /s /q "%~dp0..\bin\bink2w64_original.dll"
copy "%~dp0\bin\Backups\bink2w64.dll" "%~dp0..\bin"
copy "%~dp0\bin\Backups\modsettings.lsx" "%userprofile%\AppData\Local\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public"
del /s /q "%userprofile%\AppData\Local\Larian Studios\Baldur's Gate 3\Mods\*"
cls

:: Finish
endlocal

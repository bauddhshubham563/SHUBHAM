@echo off
:: ### START UAC SCRIPT ###

if "%2"=="firstrun" exit
cmd /c "%0" null firstrun

if "%1"=="skipuac" goto skipuacstart

:checkPrivileges
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

cd /d %~dp0
cmd /c "%0" skipuac firstrun
cd /d %~dp0

:skipuacstart

if "%2"=="firstrun" exit

:: ### END UAC SCRIPT ###

:: ### START OF YOUR OWN BATCH SCRIPT BELOW THIS LINE ###
REG DELETE HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /v Deny_All /f
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Msi.Package\DefaultIcon /v (Default) /t REG_SZ /d C:\Windows\System32\msiexec.exe,0 /f
shutdown -r -t 0
del %0
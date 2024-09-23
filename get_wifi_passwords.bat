@echo off

::developed by omidullah muradi
echo Retrieving Wi-Fi profiles and passwords...

:: Create/overwrite the wifi_pass.txt file in the current directory
set outputFile=%cd%\wifi_pass.txt
echo Wi-Fi Profiles and Passwords: > %outputFile%
echo ------------------------------------------- >> %outputFile%

:: Get list of all Wi-Fi profiles
for /f "tokens=*" %%i in ('netsh wlan show profiles') do (
    set "profile=%%i"
    
    :: Find profiles in the output and retrieve their passwords
    for /f "tokens=2 delims=:" %%a in ("%%i") do (
        set "ssid=%%a"
        setlocal enabledelayedexpansion
        for /f "tokens=*" %%p in ('netsh wlan show profile name^="!ssid:~1!" key^=clear ^| findstr /C:"Key Content"') do (
            echo !ssid:~1! >> %outputFile%
            for /f "tokens=2 delims=:" %%b in ("%%p") do echo Password: %%b >> %outputFile%
            echo ------------------------------------------- >> %outputFile%
        )
    )
)

echo Completed. Wi-Fi passwords saved to %outputFile%.
pause

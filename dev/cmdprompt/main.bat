@echo off
setlocal enabledelayedexpansion


set "target_repo=%~1"

:: if "%target_repo%" == "" (
::     echo "hi0.5"
::     echo Must specify target_repo >&2
::     exit /b 1
:: )

:: escaping the pipe to just be a character instead of a pipe. sometimes needed if you have a command within a string
:: ^|
::
:: findstr /r /C:"pattern1" /C:"pattern2" == grep -E "(pattern1|pattern2)"
:: findstr /v == grep -v
::
:: for loops
:: /f in for processes the input 1 line at a time
:: for /f "skip=1 tokens=2,3 delims= " %%i in ("Skip this line and split this line by spaces") do echo First Token: %%i, Second Token: %%j
for /f "tokens=2,3 delims= " %%i in ("Skip this line and split this line by spaces") do echo First Token: %%i, Second Token: %%j

:: tokens
for /f "tokens=*" %%i in ('git status ^| findstr /v "Session.vim" ^| findstr /r /C:"^\s*Untracked" /C:"origin"') do (
    :: i,j if using tokens=n,* above.
    :: i will have everything if tokens=*
    echo "i: %%i"
    echo "j: %%j"
    set "file=%%j"
    :: !var_name! is for when enabledelayedexpansion is enabled on the script
    if exist "!file!" (
        for %%k in ("!file!") do (
            :: dp is directory and path -- it will parse out the directory and path of the full file path in variable j
            :: nx is filename and extension -- it will parse out the filename and extension of the full file path in variable j
            set "rel_dir_path=%%~dpj"
            set "rel_dir_path=!rel_dir_path:~2,-1!"
            echo mkdir "%target_repo%\!rel_dir_path!" 2>nul
            echo copy /y "!file!" "%target_repo%\!rel_dir_path!"
        )
    )
)

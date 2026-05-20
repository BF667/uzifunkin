@echo off
title FNF: Uzi Funkin Engine - Windows Build
color 0b

echo ============================================
echo   FNF: Uzi Funkin Engine - Windows Builder
echo   Low-End Optimized Engine Build
echo ============================================
echo.

:: Check if haxelib/lime is available
where lime >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Lime not found! Make sure you have Haxe and Lime installed.
    echo Run: haxelib install lime
    pause
    exit /b 1
)

:: Ask for build type
echo Select build type:
echo [1] Release Build (Optimized .exe - Recommended for distribution)
echo [2] Debug Build (With debug tools - For development)
echo [3] Release Build with Low-End Defaults (Pre-configured for potato PCs)
echo.
set /p BUILD_TYPE="Enter choice (1/2/3): "

if "%BUILD_TYPE%"=="1" (
    echo.
    echo [BUILD] Starting Release Build for Windows x64...
    echo.
    lime build windows -release
    set BUILD_DIR=export\release\windows\bin
) else if "%BUILD_TYPE%"=="2" (
    echo.
    echo [BUILD] Starting Debug Build for Windows x64...
    echo.
    lime build windows -debug
    set BUILD_DIR=export\debug\windows\bin
) else if "%BUILD_TYPE%"=="3" (
    echo.
    echo [BUILD] Starting Release Build for Windows x64 (Low-End Defaults)...
    echo.
    lime build windows -release -DLOW_END_DEFAULT
    set BUILD_DIR=export\release\windows\bin
) else (
    echo [ERROR] Invalid choice. Exiting.
    pause
    exit /b 1
)

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Build failed! Check the error messages above.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   BUILD SUCCESSFUL!
echo ============================================
echo.

:: Find the executable
if exist "%BUILD_DIR%\UziFunkin.exe" (
    echo Executable: %BUILD_DIR%\UziFunkin.exe
) else if exist "%BUILD_DIR%\Funkin.exe" (
    echo Executable: %BUILD_DIR%\Funkin.exe
) else (
    echo Executable location: %BUILD_DIR%\
)

echo.
echo Output directory: %BUILD_DIR%\
echo.

:: Ask if user wants to copy to a custom location
set /p COPY_CHOICE="Copy build to a custom location? (y/n): "
if /i "%COPY_CHOICE%"=="y" (
    set /p COPY_PATH="Enter destination path: "
    if not exist "%COPY_PATH%" mkdir "%COPY_PATH%"
    echo Copying files...
    xcopy /E /I /Y "%BUILD_DIR%\*" "%COPY_PATH%\"
    echo Files copied to: %COPY_PATH%\
)

echo.
echo Build complete! You can find your .exe in the output directory.
pause

@echo off
echo ========================================
echo   BUILD FLUTTER WEB SAJA
echo ========================================
echo.
echo Build Flutter untuk Web (tanpa deploy)...
echo.

flutter build web --release

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Build gagal!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   BUILD BERHASIL!
echo ========================================
echo.
echo File web ada di folder: build\web
echo.
echo Untuk deploy ke Firebase, jalankan:
echo   deploy_hosting.bat
echo.
pause


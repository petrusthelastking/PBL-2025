@echo off
echo ========================================
echo   FIREBASE HOSTING - BUILD DAN DEPLOY
echo ========================================
echo.
echo Langkah 1: Build Flutter Web...
echo ----------------------------------------

flutter build web --release

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Build gagal! Periksa error di atas.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Build berhasil!
echo ========================================
echo.
echo Langkah 2: Deploy ke Firebase Hosting...
echo ----------------------------------------
echo.

firebase deploy --only hosting

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Deploy gagal!
    echo Pastikan:
    echo 1. Firebase CLI sudah terinstall
    echo 2. Sudah login dengan: firebase login
    echo 3. Project ID sudah benar di .firebaserc
    pause
    exit /b 1
)

echo.
echo ========================================
echo   DEPLOY BERHASIL!
echo ========================================
echo.
echo Website Anda sudah live di Firebase Hosting!
echo Cek URL di output di atas atau:
echo https://PROJECT-ID.web.app
echo https://PROJECT-ID.firebaseapp.com
echo.
echo (Ganti PROJECT-ID dengan ID project Anda)
echo.
pause


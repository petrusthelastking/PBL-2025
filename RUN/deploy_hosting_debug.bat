@echo off
title Firebase Hosting Deployment
color 0A

echo ========================================
echo   FIREBASE HOSTING - BUILD DAN DEPLOY
echo ========================================
echo.
echo [INFO] Script dimulai pada: %date% %time%
echo.

REM Cek apakah Flutter terinstall
echo [1/5] Checking Flutter installation...
where flutter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo [ERROR] Flutter tidak ditemukan!
    echo.
    echo Pastikan Flutter sudah terinstall dan ada di PATH.
    echo Cara cek: buka CMD baru, ketik: flutter --version
    echo.
    pause
    exit /b 1
)
echo [OK] Flutter ditemukan!
flutter --version
echo.

REM Cek apakah Firebase CLI terinstall
echo [2/5] Checking Firebase CLI installation...
where firebase >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo [ERROR] Firebase CLI tidak ditemukan!
    echo.
    echo Silakan install dengan perintah:
    echo   npm install -g firebase-tools
    echo.
    echo Jika sudah install, restart CMD/PowerShell Anda.
    echo.
    pause
    exit /b 1
)
echo [OK] Firebase CLI ditemukan!
firebase --version
echo.

REM Cek apakah sudah login Firebase
echo [3/5] Checking Firebase login status...
firebase projects:list >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo [ERROR] Belum login ke Firebase!
    echo.
    echo Silakan login dengan perintah:
    echo   firebase login
    echo.
    pause
    exit /b 1
)
echo [OK] Sudah login ke Firebase!
echo.

REM Build Flutter Web
echo [4/5] Building Flutter Web...
echo ========================================
echo.

flutter build web --release

if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo ========================================
    echo [ERROR] Build Flutter gagal!
    echo ========================================
    echo.
    echo Kemungkinan penyebab:
    echo 1. Ada error di kode Flutter
    echo 2. Dependencies belum terinstall (coba: flutter pub get)
    echo 3. Flutter SDK corrupt (coba: flutter clean)
    echo.
    echo Coba jalankan:
    echo   flutter clean
    echo   flutter pub get
    echo   flutter build web --release
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo [OK] Build berhasil!
echo ========================================
echo.

REM Deploy ke Firebase
echo [5/5] Deploying to Firebase Hosting...
echo ========================================
echo.

firebase deploy --only hosting

if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo ========================================
    echo [ERROR] Deploy gagal!
    echo ========================================
    echo.
    echo Kemungkinan penyebab:
    echo 1. Project ID salah di .firebaserc
    echo 2. Firebase Hosting belum aktif di Console
    echo 3. Permission denied (coba login ulang)
    echo.
    echo Solusi:
    echo 1. Cek file .firebaserc, pastikan Project ID benar
    echo 2. Buka Firebase Console, aktifkan Hosting
    echo 3. Coba: firebase logout, lalu firebase login
    echo.
    pause
    exit /b 1
)

echo.
color 0A
echo ========================================
echo   DEPLOY BERHASIL! SUKSES!
echo ========================================
echo.
echo Website Anda sudah LIVE di Firebase Hosting!
echo.
echo Buka URL di output di atas, atau cek di:
echo Firebase Console: https://console.firebase.google.com
echo.
echo Selesai pada: %date% %time%
echo.
echo ========================================
echo.
pause



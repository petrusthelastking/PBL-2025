@echo off
echo ========================================
echo   SETUP FIREBASE HOSTING - PERTAMA KALI
echo ========================================
echo.
echo Script ini akan membantu Anda setup Firebase Hosting
echo untuk pertama kalinya.
echo.
pause
echo.

echo Langkah 1: Cek Firebase CLI...
echo ----------------------------------------
firebase --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [!] Firebase CLI belum terinstall.
    echo.
    echo Silakan install Firebase CLI dengan perintah:
    echo   npm install -g firebase-tools
    echo.
    echo Jika belum punya Node.js, download dari:
    echo   https://nodejs.org
    echo.
    pause
    exit /b 1
)
echo [OK] Firebase CLI sudah terinstall
echo.

echo Langkah 2: Login ke Firebase...
echo ----------------------------------------
echo Browser akan terbuka untuk login.
echo Pilih akun Google yang punya project Firebase Anda.
echo.
pause

firebase login

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Login gagal!
    pause
    exit /b 1
)
echo.
echo [OK] Login berhasil!
echo.

echo Langkah 3: Cek Project ID...
echo ----------------------------------------
echo.
echo PENTING: Edit file .firebaserc dan ganti Project ID
echo dengan Project ID Firebase Anda.
echo.
echo Cara cek Project ID:
echo 1. Buka https://console.firebase.google.com
echo 2. Pilih project Anda
echo 3. Lihat Project ID di Project Settings
echo.
echo File .firebaserc lokasi:
echo %CD%\.firebaserc
echo.
notepad .firebaserc
echo.

echo Langkah 4: Test Build...
echo ----------------------------------------
echo Build Flutter web untuk memastikan tidak ada error...
echo.
flutter build web --release

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Build gagal! Perbaiki error terlebih dahulu.
    pause
    exit /b 1
)
echo.
echo [OK] Build berhasil!
echo.

echo ========================================
echo   SETUP SELESAI!
echo ========================================
echo.
echo Sekarang Anda bisa deploy dengan cara:
echo   1. Klik 2x file: deploy_hosting.bat
echo.
echo      ATAU
echo.
echo   2. Manual: firebase deploy --only hosting
echo.
echo Website akan live di:
echo   https://PROJECT-ID.web.app
echo   https://PROJECT-ID.firebaseapp.com
echo.
echo Baca panduan lengkap di: PANDUAN_HOSTING_FIREBASE.md
echo.
pause


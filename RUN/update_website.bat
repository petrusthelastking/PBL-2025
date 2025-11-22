@echo off
title Quick Update Website
color 0B

echo ╔══════════════════════════════════════════════════════════╗
echo ║                                                          ║
echo ║     🔄 QUICK UPDATE - WEBSITE UPDATE OTOMATIS 🔄         ║
echo ║                                                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo Script ini akan:
echo   ✅ Build ulang aplikasi web
echo   ✅ Deploy ke Firebase Hosting
echo   ✅ Update website otomatis
echo.
echo Pastikan Anda sudah:
echo   □ Save semua file yang diedit
echo   □ Tidak ada error di kode
echo.
pause
echo.

echo ========================================
echo   STEP 1: BUILD FLUTTER WEB
echo ========================================
echo.
echo Building... Mohon tunggu...
echo.

flutter build web --release

if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo ========================================
    echo [ERROR] BUILD GAGAL!
    echo ========================================
    echo.
    echo Ada error di kode Anda!
    echo Silakan perbaiki error di atas, lalu coba lagi.
    echo.
    echo Tips:
    echo   • Baca error message dengan teliti
    echo   • Cek file yang error
    echo   • Perbaiki kode
    echo   • Jalankan script ini lagi
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo [OK] BUILD BERHASIL!
echo ========================================
echo.

echo ========================================
echo   STEP 2: DEPLOY KE FIREBASE
echo ========================================
echo.
echo Uploading to Firebase Hosting...
echo.

firebase deploy --only hosting

if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo ========================================
    echo [ERROR] DEPLOY GAGAL!
    echo ========================================
    echo.
    echo Kemungkinan penyebab:
    echo   • Koneksi internet bermasalah
    echo   • Firebase project tidak ditemukan
    echo   • Belum login Firebase
    echo.
    echo Solusi:
    echo   • Cek koneksi internet
    echo   • Login ulang: firebase login
    echo   • Cek .firebaserc project ID
    echo.
    pause
    exit /b 1
)

echo.
color 0A
echo ╔══════════════════════════════════════════════════════════╗
echo ║                                                          ║
echo ║               ✅ WEBSITE BERHASIL DIUPDATE! ✅           ║
echo ║                                                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo Website Anda sudah LIVE dengan perubahan terbaru!
echo.
echo 🌐 Buka website Anda di browser
echo.
echo 💡 PENTING: Jika tidak terlihat update, lakukan:
echo    • Hard refresh: Ctrl + F5
echo    • Atau clear cache browser
echo    • Atau buka Incognito mode
echo.
echo ⏱️  Selesai pada: %date% %time%
echo.
echo ========================================
echo.
pause


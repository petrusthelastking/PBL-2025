@echo off
echo ========================================
echo DEPLOY FIRESTORE RULES TO FIREBASE
echo ========================================
echo.

echo [1/2] Deploying Firestore Rules...
firebase deploy --only firestore:rules

echo.
echo ========================================
if %ERRORLEVEL% EQU 0 (
    echo ✅ Firestore Rules deployed successfully!
    echo.
    echo Rules sudah aktif di Firebase.
    echo Coba tambah warga lagi sekarang!
) else (
    echo ❌ Deployment failed!
    echo.
    echo Troubleshooting:
    echo 1. Pastikan Firebase CLI sudah terinstall
    echo 2. Pastikan sudah login: firebase login
    echo 3. Pastikan project sudah dipilih: firebase use --add
    echo.
    echo Manual deployment:
    echo - Buka Firebase Console
    echo - Pilih project Anda
    echo - Klik Firestore Database ^> Rules
    echo - Copy paste isi dari firestore.rules
    echo - Klik Publish
)

echo ========================================
pause


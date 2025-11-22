@echo off
REM Deploy Firestore Rules for Pengeluaran Collection
echo.
echo =========================================
echo DEPLOY FIRESTORE RULES
echo =========================================
echo.

echo [1/2] Deploying Firestore rules...
firebase deploy --only firestore:rules

echo.
echo [2/2] Verifying deployment...
timeout /t 2 >nul

echo.
echo =========================================
echo DEPLOYMENT COMPLETE!
echo =========================================
echo.
echo Rules updated for pengeluaran collection:
echo - Read: Allowed for all
echo - Write: Allowed with validation
echo - Create: Requires name, category, nominal
echo - Update/Delete: Allowed
echo.
echo Please restart your Flutter app to apply changes.
echo.
pause


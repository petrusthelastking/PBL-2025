@echo off
echo ========================================
echo  DEPLOY FIRESTORE RULES
echo ========================================
echo.
echo Deploying simplified rules for tagihan...
echo Rules: allow read, write: if true;
echo.

firebase deploy --only firestore:rules

echo.
echo ========================================
echo  DEPLOYMENT COMPLETED
echo ========================================
echo.
echo Next steps:
echo 1. Hot restart app (press R in Flutter terminal)
echo 2. Test create tagihan
echo 3. Check console logs
echo 4. Verify in Firestore Console
echo.
pause


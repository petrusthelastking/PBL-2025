@echo off
REM Generate Dummy Pengeluaran Data to Firestore
echo.
echo =========================================
echo GENERATE DUMMY PENGELUARAN DATA
echo =========================================
echo.

echo [INFO] This will generate dummy pengeluaran data to Firestore
echo [INFO] You can control the amount from the UI
echo.

echo [1/2] Running Flutter app...
flutter run -d windows -t lib/test_generate_pengeluaran.dart

echo.
echo =========================================
echo DONE!
echo =========================================
echo.
pause


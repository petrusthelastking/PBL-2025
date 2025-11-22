@echo off
REM Generate Dummy Pemasukan Data to Firestore
echo.
echo =========================================
echo GENERATE DUMMY PEMASUKAN DATA
echo =========================================
echo.

echo [INFO] This will generate 50 dummy pemasukan records to Firestore
echo.

echo [1/2] Running Flutter app on emulator...
flutter run -d emulator-5554 -t lib/quick_generate_pemasukan.dart

echo.
echo =========================================
echo DONE!
echo =========================================
echo.
pause


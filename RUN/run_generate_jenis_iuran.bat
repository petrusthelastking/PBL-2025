@echo off
REM Generate Dummy Jenis Iuran Data to Firestore
echo.
echo =========================================
echo GENERATE DUMMY JENIS IURAN DATA
echo =========================================
echo.

echo [INFO] This will generate 20 dummy jenis iuran records to Firestore
echo [INFO] For collection: jenis_iuran
echo [INFO] Menu: Kelola Pemasukan - Tab Iuran
echo.

echo [1/2] Running Flutter app on emulator...
flutter run -d emulator-5554 -t lib/quick_generate_jenis_iuran.dart

echo.
echo =========================================
echo DONE!
echo =========================================
echo.
pause


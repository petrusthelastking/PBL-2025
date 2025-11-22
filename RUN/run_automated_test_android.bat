@echo off
echo ============================================================================
echo   AUTOMATED TEST - DATA PENDUDUK CRUD (ANDROID VERSION)
echo ============================================================================
echo   Test akan berjalan di Android Emulator/Device
echo   Login, Navigate, dan CRUD operations OTOMATIS!
echo ============================================================================
echo.

echo [INFO] Checking connected devices...
flutter devices

echo.
echo [INFO] Starting automated test on Android...
echo.

flutter drive --driver=test_driver/integration_test.dart --target=integration_test/data_penduduk/data_penduduk_crud_test.dart

echo.
echo ============================================================================
echo   TEST SELESAI!
echo ============================================================================
echo.
pause


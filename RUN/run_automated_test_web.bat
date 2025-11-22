@echo off
echo ============================================================================
echo   AUTOMATED TEST - DATA PENDUDUK CRUD (WEB VERSION)
echo ============================================================================
echo   Test akan berjalan di Chrome Browser
echo   Login, Navigate, dan CRUD operations OTOMATIS!
echo ============================================================================
echo.

echo [INFO] Starting automated test on Chrome...
echo.

flutter drive --driver=test_driver/integration_test.dart --target=integration_test/data_penduduk/data_penduduk_crud_test.dart -d chrome

echo.
echo ============================================================================
echo   TEST SELESAI!
echo ============================================================================
echo.
pause


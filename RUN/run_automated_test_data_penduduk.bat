@echo off
echo ============================================================================
echo   AUTOMATED TEST - DATA PENDUDUK CRUD
echo ============================================================================
echo   Test akan berjalan OTOMATIS tanpa interaksi manual!
echo   Login, Navigate, dan CRUD operations semua AUTOMATED!
echo ============================================================================
echo.

echo [INFO] Starting automated test...
echo.

flutter test integration_test/data_penduduk/data_penduduk_crud_test.dart

echo.
echo ============================================================================
echo   TEST SELESAI!
echo ============================================================================
echo.
pause


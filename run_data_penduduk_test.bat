@echo off
REM ============================================================================
REM RUN DATA PENDUDUK E2E TEST
REM ============================================================================
REM Script untuk menjalankan E2E Test Data Penduduk dengan mudah
REM ============================================================================

echo.
echo ============================================================================
echo   JAWARA - E2E Test Runner (Data Penduduk CRUD)
echo ============================================================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Flutter tidak ditemukan!
    echo Pastikan Flutter sudah terinstall dan ada di PATH.
    echo.
    pause
    exit /b 1
)

echo [INFO] Flutter detected: OK
echo.

REM Show menu
echo Pilih platform untuk testing:
echo.
echo   1. Chrome (Web) - RECOMMENDED, paling cepat
echo   2. Windows Desktop
echo   3. Android Emulator
echo   4. Show Available Devices
echo   5. Exit
echo.
set /p choice="Masukkan pilihan (1-5): "

if "%choice%"=="1" goto chrome
if "%choice%"=="2" goto windows
if "%choice%"=="3" goto android
if "%choice%"=="4" goto devices
if "%choice%"=="5" goto end

echo [ERROR] Pilihan tidak valid!
goto end

:chrome
echo.
echo ============================================================================
echo   Running Data Penduduk CRUD Test di Chrome (Web)
echo ============================================================================
echo.
echo [INFO] Starting Chrome...
echo [INFO] Test will cover: CREATE, READ, UPDATE, DELETE operations
echo.
flutter run -d chrome integration_test/data_penduduk/data_penduduk_crud_test.dart
goto end

:windows
echo.
echo ============================================================================
echo   Running Data Penduduk CRUD Test di Windows Desktop
echo ============================================================================
echo.
echo [INFO] Starting Windows app...
echo [INFO] Test will cover: CREATE, READ, UPDATE, DELETE operations
echo.
flutter run -d windows integration_test/data_penduduk/data_penduduk_crud_test.dart
goto end

:android
echo.
echo [INFO] Checking Android devices...
flutter devices
echo.
set /p device_id="Masukkan Device ID (atau tekan Enter untuk default): "
echo.
echo ============================================================================
echo   Running Data Penduduk CRUD Test di Android
echo ============================================================================
echo.
if "%device_id%"=="" (
    echo [INFO] Running on default device...
    flutter run integration_test/data_penduduk/data_penduduk_crud_test.dart
) else (
    echo [INFO] Running on device: %device_id%
    flutter run -d %device_id% integration_test/data_penduduk/data_penduduk_crud_test.dart
)
goto end

:devices
echo.
echo ============================================================================
echo   Available Devices
echo ============================================================================
echo.
flutter devices
echo.
pause
goto end

:end
echo.
echo ============================================================================
echo   Test Completed
echo ============================================================================
echo.
pause


@echo off
REM ============================================================================
REM RUN LOGIN E2E TEST
REM ============================================================================
REM Script untuk menjalankan E2E Test Login dengan mudah
REM ============================================================================

echo.
echo ============================================================================
echo   JAWARA - E2E Test Runner (Login Flow)
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
echo   5. Run SIMPLE test (Chrome) - For debugging
echo   6. Exit
echo.
set /p choice="Masukkan pilihan (1-6): "

if "%choice%"=="1" goto chrome
if "%choice%"=="2" goto windows
if "%choice%"=="3" goto android
if "%choice%"=="4" goto devices
if "%choice%"=="5" goto simple
if "%choice%"=="6" goto end

echo [ERROR] Pilihan tidak valid!
goto end

:chrome
echo.
echo ============================================================================
echo   Running E2E Test di Chrome (Web)
echo ============================================================================
echo.
echo [INFO] Starting Chrome...
flutter run -d chrome integration_test/auth/login_test.dart
goto end

:windows
echo.
echo ============================================================================
echo   Running E2E Test di Windows Desktop
echo ============================================================================
echo.
echo [INFO] Starting Windows app with test...
flutter run -d windows integration_test/auth/login_test.dart
goto end

:android
echo.
echo [INFO] Checking Android devices...
flutter devices
echo.
set /p device_id="Masukkan Device ID (atau tekan Enter untuk default): "
echo.
echo ============================================================================
echo   Running E2E Test di Android
echo ============================================================================
echo.
if "%device_id%"=="" (
    echo [INFO] Running on default device...
    flutter run integration_test/auth/login_test.dart
) else (
    echo [INFO] Running on device: %device_id%
    flutter run -d %device_id% integration_test/auth/login_test.dart
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

:simple
echo.
echo ============================================================================
echo   Running SIMPLE E2E Test di Chrome (Debugging Mode)
echo ============================================================================
echo.
echo [INFO] Running simplified test (single test case)...
flutter run -d chrome integration_test/auth/login_test_simple.dart
goto end

:debug
echo.
echo ============================================================================
echo   Running DEBUG Test - Check Firestore Data
echo ============================================================================
echo.
echo [INFO] This will check your Firestore user data...
echo [INFO] Look for messages about email, password, and status fields...
echo.
flutter run -d chrome integration_test/auth/debug_test.dart
goto end

:robust
echo.
echo ============================================================================
echo   Running ROBUST Test - Extended Wait Times
echo ============================================================================
echo.
echo [INFO] This test has longer wait times for slow connections...
echo [INFO] Good for when simple test fails due to timing...
echo.
flutter run -d chrome integration_test/auth/login_test_robust.dart
goto end

:end
echo ============================================================================
echo   Running ROBUST Test - Extended Wait Times
echo ============================================================================
echo.
echo [INFO] This test has longer wait times for slow connections...
echo [INFO] Good for when simple test fails due to timing...
echo.
flutter run -d chrome integration_test/auth/login_test_robust.dart
goto end

:end
echo.
echo ============================================================================
echo   Test Completed
echo ============================================================================
echo.
pause


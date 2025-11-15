@echo off
echo ========================================
echo  FIREBASE SETUP - JAWARA APP
echo ========================================
echo.

echo [1/7] Installing Flutter dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo Error: Failed to install Flutter dependencies
    pause
    exit /b 1
)
echo ✓ Flutter dependencies installed
echo.

echo [2/7] Checking Firebase CLI...
call firebase --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Firebase CLI not found. Installing...
    echo Please run: npm install -g firebase-tools
    echo Then re-run this script.
    pause
    exit /b 1
)
echo ✓ Firebase CLI found
echo.

echo [3/7] Checking FlutterFire CLI...
call flutterfire --version >nul 2>&1
if %errorlevel% neq 0 (
    echo FlutterFire CLI not found. Installing...
    call dart pub global activate flutterfire_cli
    if %errorlevel% neq 0 (
        echo Error: Failed to install FlutterFire CLI
        pause
        exit /b 1
    )
)
echo ✓ FlutterFire CLI found
echo.

echo [4/7] Configuring Firebase...
echo Please select your Firebase project when prompted.
echo.
call flutterfire configure
if %errorlevel% neq 0 (
    echo Error: Firebase configuration failed
    pause
    exit /b 1
)
echo ✓ Firebase configured
echo.

echo ========================================
echo  SETUP COMPLETE!
echo ========================================
echo.
echo Next steps:
echo 1. Setup Firebase Console (Authentication, Firestore, Storage)
echo 2. Read FIREBASE_SETUP_GUIDE.md for detailed instructions
echo 3. Run: flutter run
echo.
pause


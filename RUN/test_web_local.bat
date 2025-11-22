@echo off
echo ========================================
echo   TEST APLIKASI WEB (LOCAL)
echo ========================================
echo.
echo Script ini akan menjalankan aplikasi web
echo di browser untuk testing sebelum deploy.
echo.
echo Tekan Ctrl+C untuk stop server.
echo.
pause
echo.

echo Starting Flutter Web...
echo.
echo Website akan terbuka di: http://localhost:XXXX
echo.

flutter run -d chrome

echo.
echo ========================================
echo   Server dihentikan
echo ========================================
echo.
pause


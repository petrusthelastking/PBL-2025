@echo off
REM Migration script untuk Kelola Pengeluaran Backend CRUD
REM This script will backup old files and activate new ones

echo =========================================
echo KELOLA PENGELUARAN - MIGRATION SCRIPT
echo =========================================
echo.

set BASE_PATH=lib\features\keuangan\kelola_pengeluaran
set WIDGETS_PATH=%BASE_PATH%\widgets

echo [1/6] Backing up old kelola_pengeluaran_page.dart...
if exist "%BASE_PATH%\kelola_pengeluaran_page.dart" (
    move "%BASE_PATH%\kelola_pengeluaran_page.dart" "%BASE_PATH%\kelola_pengeluaran_page_old.dart"
    echo     ✓ Backup complete
) else (
    echo     ! File not found, skipping
)

echo.
echo [2/6] Activating new kelola_pengeluaran_page.dart...
if exist "%BASE_PATH%\kelola_pengeluaran_page_new.dart" (
    move "%BASE_PATH%\kelola_pengeluaran_page_new.dart" "%BASE_PATH%\kelola_pengeluaran_page.dart"
    echo     ✓ New file activated
) else (
    echo     ! New file not found
)

echo.
echo [3/6] Backing up old tambah_pengeluaran_page.dart...
if exist "%BASE_PATH%\tambah_pengeluaran_page.dart" (
    move "%BASE_PATH%\tambah_pengeluaran_page.dart" "%BASE_PATH%\tambah_pengeluaran_page_old.dart"
    echo     ✓ Backup complete
) else (
    echo     ! File not found, skipping
)

echo.
echo [4/6] Activating new tambah_pengeluaran_page.dart...
if exist "%BASE_PATH%\tambah_pengeluaran_page_new.dart" (
    move "%BASE_PATH%\tambah_pengeluaran_page_new.dart" "%BASE_PATH%\tambah_pengeluaran_page.dart"
    echo     ✓ New file activated
) else (
    echo     ! New file not found
)

echo.
echo [5/6] Backing up old pengeluaran_card.dart...
if exist "%WIDGETS_PATH%\pengeluaran_card.dart" (
    move "%WIDGETS_PATH%\pengeluaran_card.dart" "%WIDGETS_PATH%\pengeluaran_card_old.dart"
    echo     ✓ Backup complete
) else (
    echo     ! File not found, skipping
)

echo.
echo [6/6] Activating new pengeluaran_card.dart...
if exist "%WIDGETS_PATH%\pengeluaran_card_new.dart" (
    move "%WIDGETS_PATH%\pengeluaran_card_new.dart" "%WIDGETS_PATH%\pengeluaran_card.dart"
    echo     ✓ New file activated
) else (
    echo     ! New file not found
)

echo.
echo =========================================
echo MIGRATION COMPLETE!
echo =========================================
echo.
echo Next steps:
echo 1. Run: flutter pub get
echo 2. Run: flutter run
echo 3. Test all CRUD operations
echo.
echo Old files backed up with '_old' suffix
echo You can delete them after testing
echo.
pause


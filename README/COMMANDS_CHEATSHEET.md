# 🚀 FIREBASE SETUP - COMMANDS CHEATSHEET

Quick reference untuk semua commands yang perlu Anda jalankan.

---

## 📦 INSTALLATION COMMANDS

### Install Firebase CLI
```bash
npm install -g firebase-tools
```

### Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### Verify Installation
```bash
node --version
npm --version
firebase --version
flutterfire --version
flutter doctor -v
```

---

## 🔑 AUTHENTICATION COMMANDS

### Login Firebase
```bash
firebase login
```

### Logout Firebase
```bash
firebase logout
```

### Check Current User
```bash
firebase login:list
```

---

## ⚙️ PROJECT SETUP COMMANDS

### Install Flutter Dependencies
```bash
flutter pub get
```

### Configure Firebase
```bash
flutterfire configure
```

### Reconfigure Firebase (if needed)
```bash
flutterfire configure --force
```

### Configure for Specific Platforms
```bash
# Android only
flutterfire configure --platforms=android

# Android + iOS
flutterfire configure --platforms=android,ios

# All platforms
flutterfire configure --platforms=android,ios,web
```

---

## 🧹 CLEANUP COMMANDS

### Clean Project
```bash
flutter clean
```

### Clean + Rebuild
```bash
flutter clean && flutter pub get
```

### Remove Firebase Config (to reconfigure)
```bash
# Delete these files first:
# - lib/firebase_options.dart
# - android/app/google-services.json
# - ios/Runner/GoogleService-Info.plist

# Then run:
flutterfire configure
```

---

## 🏃 RUN COMMANDS

### Run App (Debug Mode)
```bash
flutter run
```

### Run on Specific Device
```bash
# List devices
flutter devices

# Run on specific device
flutter run -d device_id
```

### Run Release Mode
```bash
flutter run --release
```

---

## 🔍 DEBUGGING COMMANDS

### Check Flutter Setup
```bash
flutter doctor
flutter doctor -v
```

### Check Dart Version
```bash
dart --version
```

### Check Firebase Projects
```bash
firebase projects:list
```

### View Firebase Config
```bash
firebase apps:list
```

---

## 📊 FIREBASE COMMANDS

### Initialize Firebase in Project (alternative method)
```bash
firebase init
```

### Deploy Firebase (for hosting/functions)
```bash
firebase deploy
```

### View Firebase Logs
```bash
firebase functions:log
```

---

## 🛠️ TROUBLESHOOTING COMMANDS

### Fix PATH Issues (Windows)
```powershell
# Add Dart pub cache to PATH
setx PATH "%PATH%;%USERPROFILE%\AppData\Local\Pub\Cache\bin"
```

### Fix PATH Issues (Mac/Linux)
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Reload
source ~/.bashrc  # or source ~/.zshrc
```

### Clear Flutter Cache
```bash
flutter clean
flutter pub cache clean
flutter pub get
```

### Reinstall Dependencies
```bash
rm -rf pubspec.lock
flutter pub get
```

### Fix Android Build Issues
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

---

## 📱 BUILD COMMANDS

### Build APK (Android)
```bash
flutter build apk
```

### Build App Bundle (Android)
```bash
flutter build appbundle
```

### Build iOS (Mac only)
```bash
flutter build ios
```

### Build Web
```bash
flutter build web
```

---

## 🔧 CONFIGURATION FILES

### Check if Firebase is Configured
```bash
# These files should exist:
ls lib/firebase_options.dart
ls android/app/google-services.json
ls ios/Runner/GoogleService-Info.plist  # if iOS
```

---

## 📦 PACKAGE COMMANDS

### Add Package
```bash
flutter pub add package_name
```

### Remove Package
```bash
flutter pub remove package_name
```

### Upgrade Packages
```bash
flutter pub upgrade
```

### Outdated Packages
```bash
flutter pub outdated
```

---

## 🚀 QUICK SETUP SEQUENCE

Copy-paste commands ini satu per satu:

```bash
# 1. Install tools
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# 2. Login Firebase
firebase login

# 3. Install dependencies
flutter pub get

# 4. Configure Firebase
flutterfire configure

# 5. Run app
flutter run
```

---

## ⚡ ONE-LINE SETUP (After tools installed)

```bash
flutter pub get && flutterfire configure && flutter run
```

---

## 🔄 RECONFIGURE FIREBASE

Jika perlu setup ulang Firebase:

```bash
# 1. Clean
flutter clean

# 2. Reconfigure
flutterfire configure --force

# 3. Reinstall & run
flutter pub get && flutter run
```

---

## 🆘 EMERGENCY RESET

Jika ada masalah besar dan perlu reset total:

```bash
# 1. Clean everything
flutter clean
rm pubspec.lock
rm -rf build/
rm lib/firebase_options.dart
rm android/app/google-services.json

# 2. Reinstall
flutter pub get

# 3. Reconfigure
flutterfire configure

# 4. Run
flutter run
```

---

## 📝 COMMONLY USED SEQUENCES

### After Pull from Git
```bash
flutter clean
flutter pub get
flutter run
```

### After Changing Dependencies
```bash
flutter pub get
flutter run
```

### After Firebase Config Change
```bash
flutterfire configure --force
flutter clean
flutter pub get
flutter run
```

### Daily Development
```bash
flutter run  # That's it!
```

---

## 💡 PRO TIPS

### Create Alias (Mac/Linux)
Add to `~/.bashrc` or `~/.zshrc`:
```bash
alias frun="flutter run"
alias fclean="flutter clean && flutter pub get"
alias freload="flutter clean && flutter pub get && flutter run"
alias fbconfig="flutterfire configure"
```

### Create Batch Files (Windows)
Create `frun.bat`:
```batch
@echo off
flutter run
```

Create `freload.bat`:
```batch
@echo off
flutter clean
flutter pub get
flutter run
```

---

## 🎯 WORKFLOW COMMANDS

### Morning Routine (Start Development)
```bash
git pull
flutter pub get
flutter run
```

### Before Commit
```bash
flutter analyze
flutter test
git add .
git commit -m "Your message"
git push
```

### Before Deploy
```bash
flutter clean
flutter pub get
flutter build apk --release
# Test the APK
```

---

## 📞 GET HELP

### Flutter Help
```bash
flutter --help
flutter run --help
flutter build --help
```

### Firebase Help
```bash
firebase --help
firebase init --help
flutterfire --help
```

---

## ✅ VERIFICATION COMMANDS

Run these to verify everything is set up correctly:

```bash
# Check tools
node --version          # Should show version
npm --version           # Should show version
firebase --version      # Should show version
flutterfire --version   # Should show version
flutter doctor -v       # Should show all ✓

# Check files
ls lib/firebase_options.dart                    # Should exist
ls android/app/google-services.json             # Should exist

# Check Firebase
firebase login:list     # Should show your account
firebase projects:list  # Should show your projects

# Try run
flutter run            # Should build and run successfully
```

---

**Save this file for quick reference! 📌**

Kapan saja butuh command, buka file ini dan copy-paste! 🚀


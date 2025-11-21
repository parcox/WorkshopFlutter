# 📚 Sesi 1: Hello Flutter with Nylo

## 🎯 Overview Sesi

**Durasi**: 90 menit (1.5 jam) | **Branch**: `00-setup-complete` → `01-first-run` → `02-hello-modified` | **Tujuan**: Peserta berhasil menjalankan aplikasi Flutter Nylo pertama mereka dan melakukan modifikasi sederhana

---

## 📋 Agenda Sesi

### **Bagian 1: Setup & Instalasi** (30 menit)
- [x] Install Flutter SDK
- [x] Install Nylo CLI
- [x] Verify installation
- [x] Troubleshooting common issues

### **Bagian 2: Create First Project** (30 menit)
- [x] Create Nylo project
- [x] Explore folder structure
- [x] Run app di emulator/device
- [x] Hot reload demo

### **Bagian 3: First Modification** (30 menit)
- [x] Edit HomePage text
- [x] Change colors
- [x] Add icon dan button
- [x] Understand widget tree

---

## 💻 Bagian 1: Setup & Instalasi (30 menit)

### **1.1 Install Flutter SDK**

#### **Windows:**
1. Download Flutter SDK dari <https://docs.flutter.dev/get-started/install/windows>
2. Extract zip file ke lokasi (contoh: `C:\src\flutter`)
3. Tambahkan Flutter ke PATH:
   - Search "Environment Variables" di Windows
   - Edit "Path" variable
   - Add `C:\src\flutter\bin`

#### **macOS:**
```bash
# Download Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (tambahkan ke ~/.zshrc atau ~/.bashrc)
export PATH="$PATH:$HOME/development/flutter/bin"

# Apply changes
source ~/.zshrc
```

#### **Linux:**
```bash
# Download Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH
export PATH="$PATH:$HOME/development/flutter/bin"

# Apply changes
source ~/.bashrc
```

#### **Verify Installation:**
```bash
flutter --version
# Output harus menunjukkan Flutter 3.24.0 atau lebih tinggi

flutter doctor
# Check semua requirements
```

**📌 Output yang Diharapkan:**
```
Flutter 3.24.0 • channel stable
Tools • Dart 3.5.0 • DevTools 2.37.0

[✓] Flutter (Channel stable, 3.24.0, on macOS)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS (Xcode 15.0)
[✓] Chrome - develop for the web
[✓] VS Code (version 1.85.0)
[✓] Connected device (2 available)
```

---

### **1.2 Understand Metro CLI**

**Apa itu Metro?**
Metro adalah CLI tool dari Nylo untuk generate code (models, controllers, pages, dll).

**Cara Menggunakan Metro:**
```bash
# Command lengkap (tanpa alias)
dart run nylo_framework:main

# Contoh: Create model
dart run nylo_framework:main make:model Task

# Contoh: Create page
dart run nylo_framework:main make:page home_page
```

**💡 Optional: Buat Alias untuk Kemudahan**

**macOS/Linux:**
```bash
# Tambahkan alias ke bash_profile atau zshrc
sudo echo "alias metro='dart run nylo_framework:main'" >>~/.zshrc && source ~/.zshrc

# Test alias
metro
# Akan muncul Metro CLI menu
```

**Windows (PowerShell):**
```powershell
# Buat/edit PowerShell profile
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

# Edit profile
notepad $PROFILE

# Tambahkan line ini:
function metro { dart run nylo_framework:main @args }

# Save dan reload
. $PROFILE
```

Setelah setup alias, Anda bisa gunakan `metro` instead of `dart run nylo_framework:main`.

**⚠️ Catatan:**
Metro **tidak perlu** diinstall terpisah. Dia sudah include dalam Nylo project.
Anda hanya perlu run `dart run nylo_framework:main` dari dalam project folder.---

### **1.3 Setup Android Emulator (Optional)**

Jika belum punya physical device:

```bash
# Check available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>

# Atau buat emulator baru via Android Studio:
# Tools → Device Manager → Create Device → Pilih Pixel 5 → Finish
```

---

### **1.4 Verify Everything Works**

```bash
# Check Flutter doctor
flutter doctor -v

# List connected devices
flutter devices
# Harus menunjukkan minimal 1 device (emulator atau physical)
```

**✅ Checklist Setup:**
- [ ] Flutter SDK installed
- [ ] `flutter doctor` tidak ada [!] error
- [ ] Minimal 1 device available (`flutter devices`)
- [ ] Understand cara akses Metro CLI (`dart run nylo_framework:main`)

---

## 🚀 Bagian 2: Create First Project (30 menit)

### **2.1 Download Nylo Project Template**

**Ada 2 cara download Nylo:**

#### **Option 1: Git Clone (Recommended)**
```bash
# Navigate ke folder workspace
cd ~/Documents/workshop-flutter

# Clone Nylo template dari GitHub
git clone https://github.com/nylo-core/nylo.git my_todo_app

# Masuk ke folder project
cd my_todo_app

# Install dependencies
flutter pub get
```

#### **Option 2: Download ZIP**
1. Buka <https://nylo.dev/download>
2. Download Nylo template (ZIP file)
3. Extract ke folder `my_todo_app`
4. Buka terminal di folder tersebut
5. Run `flutter pub get`

**🔍 Apa yang Didapat:**
- Flutter project dengan struktur Nylo
- Dependencies sudah dikonfigurasi
- Boilerplate code siap pakai
- Metro CLI tools sudah tersedia---

### **2.2 Explore Folder Structure**

```bash
cd my_todo_app
```

**📁 Struktur Folder:**

```
my_todo_app/
├── lib/
│   ├── app/
│   │   ├── controllers/      # Business logic
│   │   ├── models/           # Data structures
│   │   └── networking/       # API calls
│   ├── resources/
│   │   ├── pages/            # UI screens
│   │   │   └── home_page.dart
│   │   └── widgets/          # Reusable widgets
│   ├── routes/
│   │   └── routes.dart       # Route definitions
│   ├── bootstrap/
│   │   └── app.dart          # App initialization
│   └── main.dart             # Entry point
├── pubspec.yaml              # Dependencies
├── .env                      # Environment variables
└── README.md
```

**💡 Penjelasan Singkat:**

- **`lib/app/`** → Logic aplikasi (controllers, models)
- **`lib/resources/pages/`** → Halaman-halaman UI
- **`lib/routes/`** → Navigasi antar halaman
- **`lib/main.dart`** → Starting point aplikasi
- **`pubspec.yaml`** → Daftar package/library yang digunakan

---

### **2.3 Run Default App**

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Atau jika ada multiple devices:
flutter run -d <device_id>
```

**📱 Expected Output:**

App akan terbuka di emulator/device dengan tampilan default Nylo:
- App bar dengan judul "Home"
- Body dengan text "Hello World" atau Nylo logo
- FloatingActionButton di kanan bawah

**🎉 Congratulations!** Anda sudah menjalankan aplikasi Flutter Nylo pertama!

---

### **2.4 Hot Reload Demo**

**Apa itu Hot Reload?**
Hot reload memungkinkan Anda melihat perubahan code secara instant tanpa restart app.

**Test Hot Reload:**

1. **Buka** `lib/resources/pages/home_page.dart`
2. **Edit** text di dalam widget:

```dart
// Find this:
Text('Hello World')

// Change to:
Text('Hello Flutter!')
```

3. **Save file** (Cmd+S / Ctrl+S)
4. **Lihat emulator** → Text akan berubah otomatis! ⚡

**Shortcut Hot Reload:**
- **VS Code**: Cmd+S / Ctrl+S (auto hot reload saat save)
- **Terminal**: Tekan `r` di terminal yang menjalankan `flutter run`
- **Hot Restart**: Tekan `R` (capital R) untuk full restart

---

## 🎨 Bagian 3: First Modification (30 menit)

### **3.1 Edit HomePage Text**

Mari kita ubah tampilan HomePage dengan sesuatu yang lebih personal.

**File**: `lib/resources/pages/home_page.dart`

#### **Sebelum:**

```dart
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class HomePage extends NyStatefulWidget {
  static const path = '/home';

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends NyState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Text("Hello World"),
      ),
    );
  }
}
```

#### **Setelah:**

```dart
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class HomePage extends NyStatefulWidget {
  static const path = '/home';

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends NyState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My ToDo App"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to My ToDo App!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Let's get things done together",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**🎨 Perubahan yang Dilakukan:**
1. ✅ AppBar title → "My ToDo App"
2. ✅ Added blue background color to AppBar
3. ✅ Added check_circle icon (size 100, blue)
4. ✅ Changed text dengan styling
5. ✅ Used Column untuk vertical layout
6. ✅ Added spacing dengan SizedBox

**Save dan lihat hasilnya!** 🚀

---

### **3.2 Add Button**

Sekarang tambahkan button di bawah text.

**Update** bagian `children` di Column:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(
      Icons.check_circle,
      size: 100,
      color: Colors.blue,
    ),
    SizedBox(height: 20),
    Text(
      "Welcome to My ToDo App!",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(height: 10),
    Text(
      "Let's get things done together",
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
    ),
    SizedBox(height: 30),
    // 🆕 Button baru
    ElevatedButton(
      onPressed: () {
        print("Button clicked!");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text(
        "Get Started",
        style: TextStyle(fontSize: 18),
      ),
    ),
  ],
)
```

**Test Button:**
1. Save file
2. Tap button di app
3. Lihat console → akan muncul "Button clicked!"

---

### **3.3 Understand Widget Tree**

**Apa itu Widget Tree?**

Di Flutter, semua yang Anda lihat di screen adalah widget. Widget disusun dalam tree structure.

**Contoh Widget Tree untuk HomePage kita:**

```
Scaffold
├── AppBar
│   └── Text ("My ToDo App")
└── body: Center
    └── Column
        ├── Icon (check_circle)
        ├── SizedBox (spacing)
        ├── Text ("Welcome...")
        ├── SizedBox (spacing)
        ├── Text ("Let's get things done...")
        ├── SizedBox (spacing)
        └── ElevatedButton
            └── Text ("Get Started")
```

**💡 Key Concepts:**

- **Scaffold**: Blueprint halaman (appBar, body, floatingActionButton)
- **Center**: Widget yang center childnya
- **Column**: Layout vertical (dari atas ke bawah)
- **Row**: Layout horizontal (dari kiri ke kanan)
- **SizedBox**: Spacing atau container dengan size tertentu
- **Padding**: Add spacing around widget

---

### **3.4 Experiment Time! 🧪**

Coba modifikasi sendiri:

#### **Challenge 1: Change Colors**
Ubah warna icon dan button ke hijau (`Colors.green`)

#### **Challenge 2: Add More Text**
Tambahkan text di bawah button: "Version 1.0"

#### **Challenge 3: Add Padding**
Wrap Column dengan Padding widget:

```dart
body: Center(
  child: Padding(
    padding: EdgeInsets.all(20),
    child: Column(
      // ... existing children
    ),
  ),
)
```

#### **Challenge 4: Add FloatingActionButton**
Tambahkan FloatingActionButton di Scaffold:

```dart
return Scaffold(
  appBar: AppBar(...),
  body: Center(...),
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      print("FAB clicked!");
    },
    child: Icon(Icons.add),
    backgroundColor: Colors.blue,
  ),
);
```

---

## 🎯 Testing & Verification

### **Checklist Sesi 1:**

- [ ] Flutter SDK installed dan verified
- [ ] Nylo CLI installed
- [ ] Project created dengan `nylo create`
- [ ] App berjalan di device/emulator
- [ ] Hot reload works
- [ ] HomePage modified (text, icon, button)
- [ ] Button onClick works (print di console)
- [ ] Understand basic widget structure

---

## 🐛 Common Issues & Solutions

### **Issue 1: "Command 'flutter' not found"**

**Symptom**: Terminal tidak recognize `flutter` command

**Solution**:
```bash
# Verify Flutter location
which flutter

# If not found, add to PATH
export PATH="$PATH:/path/to/flutter/bin"
source ~/.zshrc
```

---

### **Issue 2: "Android licenses not accepted"**

**Symptom**: `flutter doctor` shows Android licenses issue

**Solution**:
```bash
flutter doctor --android-licenses
# Press 'y' untuk accept semua licenses
```

---

### **Issue 3: "No devices found"**

**Symptom**: `flutter devices` returns empty

**Solution**:

**For Physical Device:**
- Enable USB Debugging di Developer Options
- Connect via USB
- Trust computer saat diminta

**For Emulator:**
```bash
# List available emulators
flutter emulators

# Launch specific emulator
flutter emulators --launch Pixel_5_API_33
```

---

### **Issue 4: "Gradle build failed"**

**Symptom**: Error saat build Android app

**Solution**:
```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run again
flutter run
```

---

### **Issue 5: "Hot reload not working"**

**Symptom**: Perubahan code tidak muncul di app

**Solution**:
- Press `R` (capital R) untuk hot restart
- Atau stop dan run ulang app
- Check if you saved the file (Cmd+S / Ctrl+S)

---

## 📚 Key Takeaways

✅ **Flutter SDK**:
- Cross-platform framework (Android, iOS, Web, Desktop)
- Uses Dart programming language
- Hot reload untuk fast development
- Widget-based UI architecture

✅ **Nylo Framework**:
- Micro framework built on top of Flutter
- Provides MVC-like structure
- Metro CLI untuk scaffolding (make:model, make:page, dll)
- Built-in routing dan state management

✅ **Widget Basics**:
- Everything is a widget
- Widgets arranged in tree structure
- Stateless vs Stateful widgets
- Common widgets: Scaffold, AppBar, Text, Icon, Button

✅ **Development Workflow**:
- Edit code → Save → Hot reload → See changes
- Use `print()` untuk debugging
- Check console untuk errors dan logs

---

## 📖 Resources

### **Official Docs:**
- Flutter: <https://docs.flutter.dev>
- Nylo: <https://nylo.dev/docs/6.x>
- Dart: <https://dart.dev>

### **Tutorials:**
- Flutter Codelabs: <https://docs.flutter.dev/codelabs>
- Nylo Quick Start: <https://nylo.dev/docs/6.x/installation>
- Flutter Widget Catalog: <https://docs.flutter.dev/development/ui/widgets>

### **Videos:**
- Flutter Official YouTube: <https://youtube.com/flutter>
- Flutter Widget of the Week: <https://youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG>

---

## 🔗 Navigation

[Workshop Modules](./README.md) | [Sesi 2 - UI & Navigation →](./sesi-02.md)

---

*Workshop Material - Simple ToDo List with Flutter Nylo | Dokumentasi Sesi 1 - Hello Flutter with Nylo | Terakhir diperbarui: November 21, 2025*

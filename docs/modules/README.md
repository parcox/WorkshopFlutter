# 📚 Modul Workshop Flutter Nylo + Supabase

Direktori ini berisi modul-modul pembelajaran workshop **Simple ToDo List** - aplikasi task manager sederhana untuk pemula.

**Workshop Schedule:**
- **Durasi Total**: 7.5 jam
- **Morning Session**: 08:00-11:30 (3.5 jam)
- **Break**: 11:30-12:30 (1 jam)
- **Afternoon Session**: 12:30-16:30 (4 jam)

## 📋 Daftar Modul

### **Sesi 1: Hello Flutter with Nylo** ([`sesi-01.md`](./sesi-01.md))
**Durasi**: 90 menit (08:00-09:30) | **Level**: Pemula | **Branch**: `code-01-init` → `code-02-hello-world`

**Topik:**
- ✅ Pengenalan Flutter & Nylo Framework
- ✅ Setup environment pengembangan
- ✅ Install Nylo via git clone
- ✅ Create first Nylo project
- ✅ Understanding project structure
- ✅ Run & modify app (Hello World)

**Yang akan dipelajari:**
- Instalasi Flutter SDK & setup editor
- Git clone Nylo framework dari GitHub
- Metro CLI commands (`dart run nylo_framework:main`)
- Struktur folder project Nylo
- Hot reload & hot restart
- Modifikasi UI pertama (Text, Colors, Layouts)
- Testing di emulator/device

---

### **Sesi 2: UI & Navigation** ([`sesi-02.md`](./sesi-02.md))
**Durasi**: 90 menit (09:30-11:00) | **Level**: Pemula | **Branch**: `code-03-static-ui` → `code-04-add-page` → `code-05-detail-page`

**Topik:**
- ✅ Flutter widgets fundamentals
- ✅ Scaffold, AppBar, body structure
- ✅ Container, Column, Row, ListView
- ✅ Card widget untuk task items
- ✅ Multiple pages (Home, Add, Detail)
- ✅ Navigation dengan Nylo `routeTo()`
- ✅ Passing data between pages
- ✅ FloatingActionButton & IconButton

**Yang akan dipelajari:**
- Layout widgets (Container, Column, Row)
- List widgets (ListView.builder)
- Material Design (Card, ListTile)
- Basic styling (colors, padding, borders)
- Page navigation & routing
- Parameter passing between pages
- StatelessWidget basics

---

### **Sesi 3: State Management & Local Data** ([`sesi-03.md`](./sesi-03.md))
**Durasi**: 90 menit (12:30-14:00) | **Level**: Pemula | **Branch**: `code-06-controller` → `code-07-local-crud`

**Topik:**
- ✅ Dart fundamentals (variables, functions, classes)
- ✅ Type system (int, String, bool, List, dynamic)
- ✅ Type safety explanation & best practices
- ✅ Nylo Controllers introduction
- ✅ `setState()` untuk update UI
- ✅ In-memory CRUD operations (List)
- ✅ Add, toggle, delete tasks
- ✅ State persistence dalam session

**Yang akan dipelajari:**
- Dart syntax basics (var, final, const, dynamic)
- Understanding type safety & when to use dynamic
- Controller pattern (MVVM architecture)
- Managing app state dengan Controllers
- `setState()` for UI updates
- Working with Lists (add, remove, map, where)
- Event handling (onPressed, onChanged)

---

### **Sesi 4: Model & Data Persistence** ([`sesi-04.md`](./sesi-04.md))
**Durasi**: 90 menit (14:00-15:30) | **Level**: Pemula | **Branch**: `code-08-model` → `code-09-shared-prefs` → `code-10-persistent-data`

**Topik:**
- ✅ Create Task model class
- ✅ JSON serialization (fromJson, toJson)
- ✅ SharedPreferences setup
- ✅ Save/load tasks to local storage
- ✅ Update CRUD operations dengan persistence
- ✅ Data survives app restart
- ✅ Error handling & edge cases

**Yang akan dipelajari:**
- Object-oriented programming (classes, properties)
- Model design patterns
- JSON encoding/decoding
- SharedPreferences for simple data
- Async/await basics (Future, async methods)
- Data persistence strategies
- Handling app lifecycle (init, dispose)

---

### **Sesi 5: Integrasi Supabase** ([`sesi-05.md`](./sesi-05.md))
**Durasi**: 90 menit (15:30-17:00) | **Level**: Menengah | **Branch**: `code-11-supabase-setup` → `code-12-supabase-crud` → `code-13-cloud-sync`

**Topik:**
- ✅ Pengenalan Supabase (Backend-as-a-Service)
- ✅ Create Supabase account & project
- ✅ Setup database table (SQL basics)
- ✅ Install supabase_flutter package
- ✅ Connect app to Supabase
- ✅ Migrate from SharedPreferences to Supabase
- ✅ Cloud CRUD operations
- ✅ Multi-device sync testing
- ✅ Error handling & loading states

**Yang akan dipelajari:**
- Cloud database concepts
- SQL basics (CREATE TABLE, INSERT, SELECT, UPDATE, DELETE)
- Environment variables (.env file)
- API integration (Supabase client)
- Async operations with cloud backend
- Network error handling
- Pull-to-refresh pattern
- Multi-device data synchronization

---

## 🎯 Overview Workshop

**Simple ToDo List** adalah aplikasi task management sederhana yang akan dibangun selama workshop ini menggunakan:

- **Frontend**: Flutter + Nylo Framework (MVVM architecture)
- **Backend**: Supabase (PostgreSQL database, no auth)
- **Features**: CRUD operations, data persistence, cloud sync
- **Target**: Pemula dengan minim pengalaman coding

**Progression Path:**
1. **In-Memory**: Start dengan List (Sesi 3)
2. **Local Storage**: SharedPreferences (Sesi 4)
3. **Cloud Storage**: Supabase (Sesi 5)

## 📖 Cara Menggunakan Modul

1. **Baca Overview**: Setiap modul dimulai dengan penjelasan tujuan & scope sesi
2. **Follow Step-by-Step**: Panduan sangat detail dengan screenshot & code lengkap
3. **Live Coding**: Instruktur akan coding bareng, peserta ikuti sambil praktik
4. **Test & Verify**: Setiap section ada checkpoint untuk test fitur
5. **Troubleshooting**: Ada section khusus untuk common issues

## 🛠️ Prerequisites

**Minimum Requirements:**
- ✅ Laptop/PC dengan RAM minimal 8GB (16GB recommended)
- ✅ Internet connection stabil
- ✅ Akun GitHub (untuk git clone Nylo)
- ✅ Akun Supabase (gratis) - untuk Sesi 5

**Software yang perlu diinstall:**
- ✅ Flutter SDK (>=3.24.0) - [Install Guide](https://docs.flutter.dev/get-started/install)
- ✅ Android Studio / VS Code - pilih salah satu
- ✅ Git terinstall
- ✅ Android Emulator atau device fisik

**Optional tapi helpful:**
- ✅ Dasar command line (cd, ls/dir, mkdir)
- ✅ Pernah coding sebelumnya (bahasa apapun)
- ✅ Familiar dengan Git basics

**Tidak perlu:**
- ❌ Tidak harus punya background programming
- ❌ Tidak harus paham Dart/Flutter sebelumnya
- ❌ Tidak harus install database lokal

## 🌳 Branch Strategy

Workshop menggunakan **14 branches** untuk tracking progress:

```text
main (documentation only)
├── code-01-init → code-02-hello-world (Sesi 1)
├── code-03-static-ui → code-04-add-page → code-05-detail-page (Sesi 2)
├── code-06-controller → code-07-local-crud (Sesi 3)
├── code-08-model → code-09-shared-prefs → code-10-persistent-data (Sesi 4)
├── code-11-supabase-setup → code-12-supabase-crud → code-13-cloud-sync (Sesi 5)
└── code-14-polish (Bonus)
```

**Peserta bisa:**
- ✅ Follow dari branch awal (recommended)
- ✅ Jump ke specific branch jika tertinggal
- ✅ Compare code antar branches untuk debug

**Detail lengkap**: Lihat [`WORKSHOP_OUTLINE.md`](../workshop/WORKSHOP_OUTLINE.md)

## ✨ Workshop Highlights

**Beginner-Friendly Features:**
- 🐢 **Super Slow Pace**: Every line explained, no skipping
- 📸 **Visual Aids**: Screenshots, diagrams, flowcharts
- 💬 **Banyak Comments**: Code dijelaskan dalam Bahasa Indonesia
- 🔄 **Incremental Complexity**: Baby steps, build on previous knowledge
- 🆘 **Common Issues**: Troubleshooting section di every module
- 📦 **Completed Code**: Every branch has working code untuk reference

**What You'll Build:**
```
Simple ToDo List App
├── ✅ Add tasks
├── ✅ Mark as completed
├── ✅ Edit task details
├── ✅ Delete tasks
├── ✅ Persist data locally (SharedPreferences)
└── ✅ Sync to cloud (Supabase)
```

## 📞 Support

**Selama Workshop:**
1. 🙋 Angkat tangan atau unmute untuk bertanya
2. 💬 Gunakan chat untuk quick questions
3. 🐛 Share screen jika ada error untuk debugging
4. 👥 Pair programming encouraged!

**Setelah Workshop:**
1. 📖 Re-baca dokumentasi di repository
2. 🔍 Check troubleshooting sections
3. 💡 Lihat completed code di branch
4. 📧 Email instruktur jika masih stuck

---

## 🔗 Quick Links

- **[Workshop Outline](../workshop/WORKSHOP_OUTLINE.md)** - Detailed breakdown semua sesi dengan timeline
- **[Database Schema](../database/DATABASE_SCHEMA.md)** - Setup Supabase database

---

*Dokumentasi workshop Simple ToDo List - Flutter Nylo + Supabase*
*Target: Absolute Beginners | Durasi: 7.5 jam (5 sesi) | Terakhir diperbarui: November 21, 2025*

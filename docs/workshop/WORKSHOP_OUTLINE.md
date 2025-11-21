# 📋 Workshop Outline: Flutter Nylo + Supabase

**Target Aplikasi**: Simple ToDo List (Tanpa Authentication)
**Durasi**: 7.5 jam (08:00-16:30 dengan break 11:30-12:30)
**Level**: Pemula dengan minim pengalaman coding
**Tech Stack**: Flutter + Nylo 6.x + Supabase (PostgreSQL)

---

## 🎯 Workshop Goals

Setelah workshop, peserta akan:

- ✅ Mampu menjalankan aplikasi Flutter dengan Nylo framework
- ✅ Memahami struktur dasar Flutter widgets dan navigation
- ✅ Bisa implement CRUD operations sederhana
- ✅ Mengerti konsep Model dan data persistence
- ✅ Berhasil integrasi aplikasi dengan Supabase backend

---

## 📚 Session Breakdown

### **Session 1: Hello Flutter with Nylo (1.5 jam)**

- **08:00-08:30** - Setup & Instalasi
  - Install Flutter SDK
  - Understand Metro CLI (`dart run nylo_framework:main`)
  - Setup alias (optional)
  - Verify installation
  - *Branch: `code-01-init`*

- **08:30-09:00** - Create First Project
  - Git clone Nylo: `git clone https://github.com/nylo-core/nylo.git`
  - Run `flutter pub get`
  - Explore folder structure
  - Run app di emulator/device
  - Hot reload demo
  - *Branch: `code-01-init`*

- **09:00-09:30** - First Modification
  - Edit HomePage text dan warna
  - Add icon dan button
  - Understand widget tree
  - Debug dengan hot reload
  - *Branch: `code-02-hello-world`*

**Deliverable**: App berjalan dengan custom "Hello Nylo" message

---

### **Session 2: UI & Navigation (1.5 jam)**

- **09:30-10:20** - Flutter Widgets Basics (50 menit)
  - Container, Column, Row, Padding
  - ListView untuk list items
  - Card untuk task display
  - TextField dan ElevatedButton
  - Build static task list (hardcoded data)
  - *Branch: `code-03-static-ui`*

- **10:20-10:50** - Add Task Page (30 menit)
  - Create AddTaskPage dengan Metro CLI
  - Route definitions di `routes.dart`
  - `routeTo()` untuk navigation
  - Form dengan TextField
  - *Branch: `code-04-add-page`*

- **10:50-11:00** - Detail Task Page (10 menit)
  - Create DetailTaskPage
  - Pass data via route arguments
  - Display task details
  - *Branch: `code-05-detail-page`*

**Deliverable**: 3 halaman dengan navigasi, data masih static

---

### **BREAK (11:00-11:30)** ☕ *30 menit*

---

### **Session 3: State Management & Local Data (1.5 jam)**

- **11:30-12:00** - Nylo Controllers (30 menit)
  - Create controller: `metro make:controller todo_controller`
  - `NyStatefulWidget` + `NyState`
  - Lifecycle: `init()`, `dispose()`
  - `setState()` untuk update UI
  - Binding controller ke page
  - *Branch: `code-06-controller`*

- **12:00-13:00** - Implement Local ToDo (1 jam)
  - `List<Map<String, dynamic>> tasks` di controller
  - addTask(), deleteTask(), toggleComplete()
  - Update UI dengan setState()
  - Filter: all, active, completed tasks
  - Dart type system explanation (dynamic vs type-safe)
  - *Branch: `code-07-local-crud`*

**Deliverable**: Functional ToDo app (data in-memory)

---

### **LUNCH BREAK (13:00-14:00)** 🍽️ *1 jam*

---

### **Session 4: Model & Data Persistence (1.5 jam)**

- **14:00-14:25** - Models di Nylo (25 menit)
  - Create model: `metro make:model task`
  - Properties: id, title, description, isCompleted, createdAt
  - `fromJson()` dan `toJson()` methods
  - Replace Map dengan Task objects
  - *Branch: `code-08-model`*

- **14:25-15:00** - SharedPreferences (35 menit)
  - Add dependency `shared_preferences`
  - Save tasks: `jsonEncode(tasks)`
  - Load tasks: `jsonDecode()`
  - Auto-load di `init()`
  - Auto-save setiap CRUD operation
  - *Branch: `code-09-shared-prefs`*

- **15:00-15:30** - Testing & Refinement (30 menit)
  - Add beberapa tasks
  - Restart app → data tetap ada
  - Test delete, toggle complete
  - Handle empty state
  - Polish UI
  - *Branch: `code-10-persistent-data`*

**Deliverable**: ToDo app dengan data persistence lokal

---

### **Session 5: Integrasi Supabase (1.5 jam)**

- **15:30-15:45** - Setup Supabase (15 menit)
  - Create project di supabase.com
  - Create table `tasks` via SQL Editor
  - Disable RLS untuk kesederhanaan
  - Copy API URL dan anon key
  - *Branch: `code-11-supabase-setup`*

- **15:45-16:10** - Connect to Supabase (25 menit)
  - Add `supabase_flutter` dependency
  - Initialize Supabase client
  - Create `supabase_service.dart`
  - Replace local CRUD dengan Supabase CRUD
  - Error handling basics
  - *Branch: `code-12-supabase-crud`*

- **16:10-16:30** - Testing & Demo (20 menit)
  - Test app di 2 devices
  - Add task di device 1 → refresh di device 2
  - Troubleshooting common issues
  - Q&A
  - *Branch: `code-13-cloud-sync`*

**Deliverable**: ToDo app fully connected ke Supabase

---

### **BONUS: Final Polish (jika ada waktu)**

- **16:30-17:00** - Extra features
  - Loading indicators
  - Error handling improvements
  - Pull-to-refresh
  - *Branch: `code-14-polish`*

---

## 🌳 Git Branch Strategy

```text
main (documentation only)
├── code-01-init (Base Nylo, Flutter setup verified)
├── code-02-hello-world (Custom HomePage)
├── code-03-static-ui (Static task list with 3 items)
├── code-04-add-page (AddTaskPage form)
├── code-05-detail-page (DetailTaskPage)
├── code-06-controller (TodoController setup)
├── code-07-local-crud (In-memory CRUD works)
├── code-08-model (Task model class)
├── code-09-shared-prefs (SharedPreferences integration)
├── code-10-persistent-data (All CRUD persistent locally)
├── code-11-supabase-setup (Supabase table created)
├── code-12-supabase-crud (Supabase integration)
├── code-13-cloud-sync (Complete app with cloud sync)
└── code-14-polish (Final polish & extras)
```

**Setiap branch**:

- Memiliki working code untuk checkpoint tersebut
- Bisa di-run independently
- Include README.md dengan instruksi

---

## 📁 Project Structure (Final)

```text
lib/
├── bootstrap.dart               # App initialization
├── app/
│   ├── controllers/
│   │   └── todo_controller.dart  # Business logic
│   ├── models/
│   │   └── task.dart             # Task data model
│   └── networking/
│       └── supabase_service.dart # Supabase API calls
├── resources/
│   ├── pages/
│   │   ├── home_page.dart        # Main todo list
│   │   ├── add_task_page.dart    # Add new task form
│   │   └── detail_task_page.dart # View/edit task
│   └── widgets/
│       └── task_card.dart        # Reusable task item widget
└── routes/
    └── routes.dart               # Route definitions
```

---

## 🎯 Learning Outcomes

Peserta akan memahami & mampu:

1. ✅ Setup Flutter project dengan Nylo framework
2. ✅ Build UI dengan Flutter widgets dasar
3. ✅ Implement navigation antar halaman
4. ✅ Manage state dengan Nylo Controllers
5. ✅ Create data models dan serialization
6. ✅ Persist data dengan SharedPreferences
7. ✅ Connect aplikasi ke Supabase backend
8. ✅ Implement CRUD operations dengan database cloud

---

## 🛠️ Prerequisites untuk Peserta

### Sebelum Workshop

- [ ] Laptop dengan RAM minimal 8GB
- [ ] Install Flutter SDK (>= 3.24.0)
- [ ] Install Android Studio atau Xcode
- [ ] Setup emulator atau connect physical device
- [ ] Install Git
- [ ] Create akun Supabase (gratis)

### Nice to Have

- [ ] Familiar dengan basic programming concepts
- [ ] Pernah lihat/coba Flutter sekali
- [ ] Understand JSON format

---

## 📞 Support & Resources

### During Workshop

- Instruktur live coding di proyektor
- GitHub repository dengan completed code per branch
- Discord/Slack channel untuk Q&A
- Pair programming encouraged

### After Workshop

- Recording video (jika ada)
- Access ke repository selamanya
- Follow-up Q&A session (optional)

### Recommended Learning

- Flutter Docs: <https://docs.flutter.dev>
- Nylo Docs: <https://nylo.dev/docs/6.x>
- Supabase Docs: <https://supabase.com/docs>
- Dart Language Tour: <https://dart.dev/guides/language/language-tour>

---

*Workshop Material - Simple ToDo List with Flutter Nylo + Supabase*
*Target: Pemula dengan minim pengalaman coding*
*Last updated: November 21, 2025*

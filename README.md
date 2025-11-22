# 📱 Simple ToDo List - Workshop Flutter Nylo + Supabase

> **Workshop untuk absolute beginners** - Build your first Flutter app dari nol!

Aplikasi **ToDo List sederhana** untuk belajar Flutter, Nylo framework, dan Supabase cloud database.

## 🎯 About This Workshop

**Target Audience**: Pemula dengan minim atau tanpa pengalaman coding
**Duration**: 7.5 jam (5 sesi) - 08:00-16:30 dengan break 11:30-12:30
**Outcome**: Working ToDo List app dengan cloud sync

**What You'll Learn:**
- ✅ Flutter basics (UI widgets, navigation)
- ✅ Dart programming fundamentals
- ✅ State management dengan Controllers
- ✅ Data persistence (local & cloud)
- ✅ Supabase database integration

**What You'll Build:**
```
Simple ToDo List App
├── Add new tasks
├── Mark tasks as completed
├── Edit task details
├── Delete tasks
├── Data persists after restart
└── Cloud sync (Supabase)
```

---

## 🚀 Quick Start (For Workshop Participants)

### Prerequisites

**Software:**
- ✅ Flutter SDK (>=3.24.0) - [Install Guide](https://docs.flutter.dev/get-started/install)
- ✅ Android Studio **OR** VS Code (pilih salah satu)
- ✅ Git installed
- ✅ Android Emulator atau physical device

**Accounts:**
- ✅ GitHub account (untuk clone Nylo)
- ✅ Supabase account (gratis) - untuk Sesi 5 saja

**Minimum Hardware:**
- RAM: 8GB (16GB recommended)
- Storage: 10GB free space
- Internet: Stable connection

### Setup Instructions

**Option A: Fresh Start (Recommended untuk Workshop)**

Follow Sesi 1 documentation - we'll setup everything together!
👉 [`docs/modules/sesi-01.md`](./docs/modules/sesi-01.md)

**Option B: Clone This Repo (Jika mau lihat completed code)**

```bash
# 1. Clone repository
git clone https://github.com/your-username/WorkshopFlutter.git
cd WorkshopFlutter

# 2. Checkout ke specific branch
git checkout code-01-init        # Start from beginning
# atau
git checkout code-07-local-crud  # Jump to specific session
# atau
git checkout code-13-cloud-sync  # See final result

# 3. Install dependencies
flutter pub get

# 4. Run aplikasi
flutter run
```

---

## 📚 Workshop Sessions & Branches

Workshop dibagi menjadi **5 sesi** dengan **14 branches** untuk tracking progress:

| Sesi | Topic | Durasi | Branches | Status |
|------|-------|--------|----------|--------|
| **Sesi 1** | Hello Flutter with Nylo | 1.5 jam | `code-01-init`, `code-02-hello-world` | Setup & first app ✅ |
| **Sesi 2** | UI & Navigation | 1.5 jam | `code-03-static-ui`, `code-04-add-page`, `code-05-detail-page` | 3 pages built ✅ |
| **Sesi 3** | State Management | 1.5 jam | `code-06-controller`, `code-07-local-crud` | In-memory CRUD ✅ |
| **Sesi 4** | Model & Data Persistence | 1.5 jam | `code-08-model`, `code-09-shared-prefs`, `code-10-persistent-data` | Local storage ✅ |
| **Sesi 5** | Integrasi Supabase | 1.5 jam | `code-11-supabase-setup`, `code-12-supabase-crud`, `code-13-cloud-sync` | Cloud sync ✅ |
| **Bonus** | Final Polish | 30 min | `code-14-polish` | Extra features 🎁 |

**How to use branches:**
```bash
# See all branches
git branch -a

# Switch ke specific branch
git checkout code-03-static-ui

# Compare with previous branch
git diff code-02-hello-world code-03-static-ui

# See current branch
git branch --show-current
```

**Detail lengkap setiap sesi**: 👉 [`docs/workshop/WORKSHOP_OUTLINE.md`](./docs/workshop/WORKSHOP_OUTLINE.md)

---

## 📁 Project Structure (Simplified)

```
lib/
├── main.dart                      # Entry point
├── app/
│   ├── controllers/
│   │   └── todo_home_controller.dart   # Business logic
│   ├── models/
│   │   └── task.dart                   # Task data structure
│   ├── services/
│   │   ├── storage_service.dart        # SharedPreferences (Sesi 4)
│   │   └── supabase_service.dart       # Supabase API (Sesi 5)
│   └── networking/
│       └── supabase_service.dart       # Cloud database calls
└── resources/
    └── pages/
        ├── todo_home_page.dart         # Main screen (list)
        ├── add_task_page.dart          # Add new task
        └── detail_task_page.dart       # View/edit task
```

**Simple & Clean:**
- ✅ **No authentication** - simpler untuk pemula
- ✅ **Single model** - hanya Task class
- ✅ **One controller** - TodoHomeController untuk semua logic
- ✅ **Three pages** - Home, Add, Detail
- ✅ **Progressive** - Start simple, add complexity step-by-step

## 🎯 Learning Objectives

**By the end of this workshop, you'll be able to:**

**Sesi 1-2: Flutter Basics**
- ✅ Create & run Flutter app
- ✅ Understand widget tree (Container, Column, Row, ListView)
- ✅ Build multi-page apps dengan navigation
- ✅ Use FloatingActionButton & IconButton

**Sesi 3: Programming Fundamentals**
- ✅ Write Dart code (variables, functions, classes)
- ✅ Understand type system & type safety
- ✅ Use Controllers untuk manage state
- ✅ Implement CRUD operations dalam memory

**Sesi 4: Data Persistence**
- ✅ Create Model classes
- ✅ JSON serialization (toJson/fromJson)
- ✅ Save data dengan SharedPreferences
- ✅ Handle async operations (Future, async/await)

**Sesi 5: Cloud Integration**
- ✅ Setup Supabase account & database
- ✅ Write basic SQL queries
- ✅ Connect app to cloud backend
- ✅ Implement cloud CRUD operations
- ✅ Test multi-device sync

## 🔧 Tech Stack (Beginner-Friendly)

- **Frontend**: Flutter 3.24+ (cross-platform UI framework)
- **Framework**: Nylo 6.x (micro framework for Flutter - simplifies MVVM)
- **Local Storage**: SharedPreferences (Sesi 4)
- **Cloud Backend**: Supabase (PostgreSQL database, no auth for simplicity)
- **State Management**: Nylo Controllers (MVVM pattern)

**Why This Stack?**
- ✅ **Flutter**: Beautiful UI, hot reload, cross-platform
- ✅ **Nylo**: Simpler structure than pure Flutter, MVVM built-in
- ✅ **Supabase**: Free tier, no complex setup, PostgreSQL power

---

## 📖 Documentation

**Start Here:**
- 📚 **[Module Index](./docs/modules/README.md)** - Overview semua 5 sesi
- 📋 **[Workshop Outline](./docs/workshop/WORKSHOP_OUTLINE.md)** - Detailed breakdown 8 jam
- 🌳 **[Branch Guide](./docs/workshop/BRANCH_GUIDE.md)** - How to use git branches

**Session Materials:**
- 📄 **[Sesi 1 - Hello Flutter with Nylo](./docs/modules/sesi-01.md)** - Setup & first app
- 📄 **[Sesi 2 - UI & Navigation](./docs/modules/sesi-02.md)** - Build 3 pages
- 📄 **[Sesi 3 - State Management](./docs/modules/sesi-03.md)** - Dart basics & Controllers
- 📄 **[Sesi 4 - Data Persistence](./docs/modules/sesi-04.md)** - Models & SharedPreferences
- 📄 **[Sesi 5 - Integrasi Supabase](./docs/modules/sesi-05.md)** - Cloud database

**Technical References:**
- 🗄️ **[Database Schema](./docs/database/DATABASE_SCHEMA.md)** - Supabase setup & SQL
- 🤖 **[Copilot Instructions](./.github/copilot-instructions.md)** - AI assistant context

---

## 🆘 Troubleshooting

**Before Workshop:**

**Q: "Flutter not found" atau "dart not found"**
```bash
# Check installation
flutter --version

# If not found, install Flutter SDK
# https://docs.flutter.dev/get-started/install
```

**Q: "Android emulator tidak jalan"**
- Buka Android Studio → AVD Manager
- Create new virtual device (Pixel 5, API 30+)
- Atau connect physical device via USB debugging

**During Workshop:**

**Q: "Metro command not found"**
```bash
# Metro is an alias. Use full command:
dart run nylo_framework:main make:page MyPage
```

**Q: "Hot reload tidak work"**
- Try Hot Restart: Shift + R
- If still fails: Stop app & run again

**Q: "pubspec.yaml error"**
- Check indentation (YAML sensitive to spaces!)
- Run `flutter pub get` after editing

**Q: "Supabase connection failed"**
- Check internet connection
- Verify `.env` file exists & has correct values
- Try accessing Supabase URL di browser

**More troubleshooting**: Setiap sesi punya section **Common Issues & Solutions**

---

## 👥 For Instructors

**Workshop Delivery Tips:**
- 🐢 **Code slowly** - Type every line, explain every concept
- ⏸️ **Pause frequently** - Check if peserta masih follow
- 📸 **Share screen** - Show every step, including clicks
- 🔄 **Recap often** - Summarize what was done every 15 minutes
- 🆘 **Prepare for errors** - Have troubleshooting steps ready
- 🎯 **Set checkpoints** - Test together at end of each section

**Pacing:**
- Break every 45 minutes (5-10 min break)
- OK jika tidak finish semua - focus on understanding
- Encourage pair programming & peer help

---

## 📞 Support & Community

**During Workshop:**
- 🙋 Raise hand / unmute untuk bertanya
- 💬 Use chat untuk quick questions
- 🤝 Ask fellow participants (pair programming!)

**After Workshop:**
- 📧 Email instruktur jika stuck
- 📖 Re-read documentation materials
- 💻 Check completed code di branches
- 🐛 Submit issue di repository

---

## 🎁 What's Next? (After Workshop)

**Improvements You Can Add:**
1. **User Authentication** - Add login dengan Supabase Auth
2. **Categories** - Create multiple task lists
3. **Due Dates** - Add reminders & notifications
4. **Search & Filter** - Find tasks easily
5. **Dark Mode** - Theme switching
6. **Offline Mode** - Sync when back online (Hive)
7. **Sharing** - Collaborate dengan friends

**Resources untuk Lanjutan:**
- 📚 [Flutter Documentation](https://docs.flutter.dev/)
- 🎓 [Nylo Framework Docs](https://nylo.dev)
- 🔥 [Supabase Docs](https://supabase.com/docs)
- 🎥 [Flutter YouTube Channel](https://www.youtube.com/@flutterdev)

---

## 👨‍🏫 Instructor

**Fitri Wibowo**
- 📧 Email: fitri.wibowo@polnep.ac.id
- 🏫 Politeknik Negeri Pontianak

---

## 📄 License

MIT License - Workshop Material

---

## 🙏 Acknowledgments

- **Flutter Team** - For amazing framework
- **Nylo Framework** - For simplifying Flutter development
- **Supabase** - For generous free tier & great docs
- **Workshop Participants** - For your enthusiasm & feedback!

---

<div align="center">

**Happy Coding! 🚀**

*Built with ❤️ for absolute beginners*

*Last Updated: November 22, 2025*

</div>

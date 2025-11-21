# 📚 Dokumentasi Workshop

Dokumentasi lengkap untuk **Workshop Flutter Nylo + Supabase** - Build Simple ToDo List App.

## 📁 Struktur Dokumentasi

```
docs/
├── README.md                    # Index dokumentasi (file ini)
├── workshop/                    # Materi workshop
│   ├── WORKSHOP_OUTLINE.md     # Outline workshop 7.5 jam
│   └── BRANCH_GUIDE.md         # Panduan branch strategy (TBD)
├── database/                    # Database & backend
│   └── DATABASE_SCHEMA.md      # Schema Supabase lengkap
└── modules/                     # Modul pembelajaran detail
    ├── README.md                # Index modul
    ├── sesi-01.md               # Session 1: Setup & Hello World
    ├── sesi-02.md               # Session 2: UI & Navigation
    ├── sesi-03.md               # Session 3: State Management
    ├── sesi-04.md               # Session 4: Data Persistence
    └── sesi-05.md               # Session 5: Supabase Integration
```

## 🚀 Akses Cepat

### **Materi Workshop**
- **[Workshop Outline](./workshop/WORKSHOP_OUTLINE.md)** - Breakdown materi 7.5 jam lengkap

### **Modul Detail**
- **[Module Index](./modules/README.md)** - Overview semua 5 sesi
- **[Sesi 1: Hello Flutter with Nylo](./modules/sesi-01.md)** - Setup & first app
- **[Sesi 2: UI & Navigation](./modules/sesi-02.md)** - Build 3 pages dengan static data
- **[Sesi 3: State Management](./modules/sesi-03.md)** - Controllers & in-memory CRUD
- **[Sesi 4: Data Persistence](./modules/sesi-04.md)** - Models & SharedPreferences
- **[Sesi 5: Integrasi Supabase](./modules/sesi-05.md)** - Cloud database integration

### **Dokumentasi Teknis**
- **[Database Schema](./database/DATABASE_SCHEMA.md)** - Setup Supabase & SQL scripts

### **Setup Development**
- **[Main README](../README.md)** - Quick start & project overview
- **[Copilot Instructions](../.github/copilot-instructions.md)** - Panduan AI assistant

## 🎯 Overview Workshop

**Simple ToDo List** - Aplikasi Task Manager Sederhana untuk Pemula
- **Durasi**: 7.5 jam (08:00-16:30 dengan break 11:30-12:30)
- **Tech Stack**: Flutter + Nylo + Supabase
- **Fitur**: CRUD operations + Data Persistence + Cloud Sync
- **Target**: Absolute beginners dengan minim pengalaman coding

## 📋 Sesi Workshop

1. **Hello Flutter with Nylo** (1.5 jam) - Setup & first app
2. **UI & Navigation** (1.5 jam) - Build 3 pages dengan static data
3. **State Management** (1.5 jam) - Controllers & in-memory CRUD
4. **Data Persistence** (1.5 jam) - Models & local storage (SharedPreferences)
5. **Integrasi Supabase** (1.5 jam) - Cloud database & sync

## 🌳 Strategi Branch

Workshop menggunakan **orphan branches** untuk setiap code checkpoint:
- `main` (documentation only)
- `code-01-init` → `code-02-hello-world` (Sesi 1)
- `code-03-static-ui` → `code-04-add-page` → `code-05-detail-page` (Sesi 2)
- `code-06-controller` → `code-07-local-crud` (Sesi 3)
- `code-08-model` → `code-09-shared-prefs` → `code-10-persistent-data` (Sesi 4)
- `code-11-supabase-setup` → `code-12-supabase-crud` → `code-13-cloud-sync` (Sesi 5)
- `code-14-polish` (Bonus)

Setiap peserta bisa checkout ke branch manapun untuk follow along atau catch up.

## 🛠️ Prasyarat Development

- Flutter SDK (>=3.24.0)
- Dart SDK (>=3.5.0)
- Git
- Akun Supabase (tier gratis OK)

## 📖 Resources Eksternal

- **Nylo Framework**: https://nylo.dev
- **Supabase Docs**: https://supabase.com/docs
- **Flutter Docs**: https://flutter.dev/docs

## 🆘 Dukungan

- **Issues**: Buat GitHub issue
- **Diskusi**: Channel workshop
- **Updates**: Periksa dokumentasi ini secara berkala

---

*Dokumentasi dikelola untuk Workshop Flutter Nylo + Supabase*
*Terakhir diperbarui: November 21, 2025*
# 🎯 Simple ToDo App

A beautiful and functional todo list application built with Flutter, Nylo Framework, and Supabase.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter)
![Supabase](https://img.shields.io/badge/Supabase-Enabled-3ECF8E?logo=supabase)

## ✨ Features

- ✅ **Full CRUD Operations** - Create, Read, Update, Delete tasks
- ✅ **Cloud Storage** - Data stored in Supabase PostgreSQL
- ✅ **Multi-Device Sync** - Tasks automatically sync across devices
- ✅ **Pull-to-Refresh** - Swipe down to refresh data
- ✅ **Beautiful UI** - Modern design with animations
- ✅ **Error Handling** - Graceful error messages with retry
- ✅ **Loading States** - Visual feedback during operations
- ✅ **Date Formatting** - Human-readable date and time
- ✅ **Connection Status** - Real-time connection indicator
- ✅ **Responsive Design** - Works on phones and tablets

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.24.0)
- Dart SDK (>= 3.5.0)
- Android Studio / Xcode
- Supabase Account (free tier)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd simple_todo_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase:**

   a. Create a project at [supabase.com](https://supabase.com)

   b. Run this SQL in Supabase SQL Editor:
   ```sql
   CREATE TABLE tasks (
     id TEXT PRIMARY KEY,
     title TEXT NOT NULL,
     description TEXT DEFAULT '',
     is_completed BOOLEAN DEFAULT false,
     created_at TIMESTAMP WITH TIME ZONE NOT NULL,
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   ALTER TABLE tasks DISABLE ROW LEVEL SECURITY;
   ```

   c. Create `.env` file in project root:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 📱 Usage

- **Add Task:** Tap the "Add Task" button → Fill in title and description → Save
- **View Details:** Tap any task card to see full details
- **Toggle Status:** Tap the status button in detail page to mark as completed/pending
- **Delete Task:** Tap delete icon in detail page
- **Refresh:** Pull down the list or tap the refresh icon
- **Clear All:** Tap menu (⋮) → Clear All Tasks

## 🏗️ Project Structure

```
lib/
├── main.dart                      # App entry point
├── app/
│   ├── controllers/
│   │   └── todo_home_controller.dart  # Business logic & state
│   ├── models/
│   │   └── task.dart                  # Task data model
│   └── services/
│       ├── supabase_service.dart      # Supabase API calls
│       └── storage_service.dart       # Local storage (legacy)
└── resources/
    └── pages/
        ├── todo_home_page.dart        # Main list view
        ├── add_task_page.dart         # Add task form
        └── detail_task_page.dart      # Task details
```

## 🛠️ Technologies Used

- **Flutter** - UI framework
- **Nylo Framework** - State management & routing
- **Supabase** - Backend-as-a-Service (PostgreSQL)
- **SharedPreferences** - Local caching (optional)
- **Intl** - Date/time formatting

## 🧪 Testing

### Manual Testing Checklist

- [ ] Add new task → appears in list
- [ ] Edit task status → updates immediately
- [ ] Delete task → removes from list
- [ ] Close and reopen app → data persists
- [ ] Add task on device A → refresh on device B → task appears
- [ ] Turn off wifi → error message appears
- [ ] Turn on wifi → retry → app works again

### Multi-Device Sync Test

1. Install app on 2 devices
2. Add task on device 1
3. Pull-to-refresh on device 2
4. Task should appear on device 2 ✨

## 🐛 Troubleshooting

**Connection Error:**
- Check internet connection
- Verify `.env` file has correct credentials
- Ensure Supabase project is active

**Tasks Not Syncing:**
- Pull down to refresh manually
- Check both devices use same Supabase project
- Verify RLS is disabled in Supabase

**Build Errors:**
- Run `flutter clean && flutter pub get`
- Ensure Flutter SDK is up to date
- Check `.env` file exists and is in `.gitignore`

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Nylo Framework](https://nylo.dev/docs/6.x)
- [Supabase Docs](https://supabase.com/docs)

## 🎯 Future Enhancements

- [ ] User authentication
- [ ] Row Level Security (RLS)
- [ ] Real-time sync (Supabase Realtime)
- [ ] Offline-first with local caching
- [ ] Search and filter
- [ ] Categories/tags
- [ ] Due dates & reminders
- [ ] Priority levels
- [ ] Task sharing

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

Created as part of Flutter + Nylo + Supabase Workshop

---

**Made with ❤️ and Flutter**

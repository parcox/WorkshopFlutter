# ☁️ Sesi 5: Integrasi Supabase

## 🎯 Overview Sesi

**Durasi**: 90 menit (1.5 jam) | **Branch**: `11-supabase-setup` → `12-supabase-crud` → `13-cloud-sync` | **Tujuan**: Migrate dari SharedPreferences ke Supabase database untuk cloud storage

---

## 📋 Agenda Sesi

### **Bagian 1: Supabase Setup** (30 menit)

- [x] Create Supabase account & project
- [x] Create tasks table dengan SQL
- [x] Disable RLS untuk kesederhanaan
- [x] Install supabase_flutter package
- [x] Initialize Supabase di app

### **Bagian 2: Replace Storage dengan Supabase** (35 menit)

- [x] Create SupabaseService class
- [x] Implement CRUD methods dengan Supabase
- [x] Update Controller untuk pakai SupabaseService
- [x] Handle async operations

### **Bagian 3: Testing & Polish** (25 menit)

- [x] Test all CRUD operations
- [x] Handle errors & edge cases
- [x] Loading states & feedback
- [x] Final testing & demo

---

## 🚀 Bagian 1: Supabase Setup (30 menit)

### **1.1 What is Supabase?**

**Supabase** adalah Backend-as-a-Service (BaaS) - backend siap pakai berbasis PostgreSQL.

**Analogi:**
- **SharedPreferences** = Lemari di rumah (hanya bisa akses dari rumah sendiri)
- **Supabase** = Cloud storage (bisa akses dari mana saja, device mana saja)

**Keuntungan Supabase:**
- ✅ **Cloud storage**: Data tersimpan di cloud, tidak hilang meski uninstall app
- ✅ **Multi-device sync**: Data sama di semua device
- ✅ **Real database**: PostgreSQL - powerful, scalable
- ✅ **Free tier**: Generous free plan untuk belajar
- ✅ **Easy to use**: Simple API, mirip seperti Firebase

**Kapan pakai Supabase?**
- ✅ Data perlu sync antar devices
- ✅ Data perlu backup di cloud
- ✅ Multiple users
- ✅ Data relational (ada relasi antar table)

---

### **1.2 Create Supabase Account & Project**

#### **Langkah 1: Sign Up**

1. Buka https://supabase.com
2. Klik **Start your project**
3. Sign up dengan GitHub account (recommended) atau email
4. Verify email jika pakai email signup

#### **Langkah 2: Create New Project**

1. Klik **New Project**
2. Pilih organization (atau buat baru)
3. Isi form:
   - **Name**: `todo-app-workshop` (atau nama bebas)
   - **Database Password**: Buat password kuat (simpan baik-baik!)
   - **Region**: Pilih yang terdekat (e.g., `Southeast Asia (Singapore)`)
   - **Pricing Plan**: **Free** (sudah cukup untuk workshop)
4. Klik **Create new project**
5. Tunggu ~2 menit project selesai di-setup

---

### **1.3 Create Tasks Table**

#### **Langkah 1: Open SQL Editor**

1. Di Supabase Dashboard, klik **SQL Editor** di sidebar
2. Klik **New query**

#### **Langkah 2: Create Table dengan SQL**

Copy dan paste SQL ini, lalu klik **Run**:

```sql
-- Create tasks table
CREATE TABLE tasks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  is_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index untuk performa
CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);
CREATE INDEX idx_tasks_is_completed ON tasks(is_completed);

-- Add trigger untuk auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_tasks_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data untuk testing
INSERT INTO tasks (id, title, description, is_completed, created_at)
VALUES
  ('sample-1', 'Welcome to Supabase!', 'This is a sample task from cloud database', false, NOW()),
  ('sample-2', 'Test cloud sync', 'Try adding, editing, and deleting tasks', false, NOW());
```

**💡 Penjelasan:**

- **id TEXT PRIMARY KEY**: ID sebagai string (sama seperti di app)
- **title TEXT NOT NULL**: Title wajib diisi
- **description TEXT DEFAULT ''**: Description optional, default empty
- **is_completed BOOLEAN**: Status completed true/false
- **created_at**: Timestamp kapan dibuat
- **updated_at**: Auto-update setiap kali record di-update (via trigger)

#### **Langkah 3: Verify Table Created**

1. Klik **Table Editor** di sidebar
2. Lihat table `tasks` dengan 2 sample rows
3. Coba klik row untuk lihat detail

---

### **1.4 Disable RLS (Row Level Security)**

Untuk workshop ini, kita disable RLS agar lebih sederhana (tidak perlu authentication).

⚠️ **Note**: Di production app, WAJIB pakai RLS + Auth untuk security!

#### **Langkah 1: Open SQL Editor**

Jalankan SQL ini:

```sql
-- Disable RLS untuk tasks table
ALTER TABLE tasks DISABLE ROW LEVEL SECURITY;
```

Sekarang semua client bisa akses data tanpa authentication.

---

### **1.5 Get API Keys**

#### **Langkah 1: Open Project Settings**

1. Klik **Settings** icon (gear) di sidebar bawah
2. Klik **API**

#### **Langkah 2: Copy Keys**

Copy 2 values ini (simpan di notepad):
- **Project URL**: `https://xxxxx.supabase.co`
- **anon/public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9....` (long string)

---

### **1.6 Install Supabase Flutter Package**

#### **Langkah 1: Add Dependencies**

**Edit file: `pubspec.yaml`**

```yaml
dependencies:
  flutter:
    sdk: flutter
  nylo_framework: ^6.9.1
  shared_preferences: ^2.5.3
  supabase_flutter: ^2.9.1  # Tambahkan ini
```

#### **Langkah 2: Install Package**

```bash
flutter pub get
```

---

### **1.7 Initialize Supabase di App**

#### **Langkah 1: Create .env File**

**Create file: `.env` (di root project, sejajar dengan `pubspec.yaml`)**

```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

**⚠️ PENTING:**
- Ganti `your-project.supabase.co` dengan Project URL Anda
- Ganti `your-anon-key-here` dengan anon key Anda

#### **Langkah 2: Add .env ke .gitignore**

**Edit file: `.gitignore`**

Tambahkan di baris paling bawah:

```
# Environment variables
.env
```

Ini penting agar API keys tidak ter-commit ke git!

#### **Langkah 3: Load .env di pubspec.yaml**

**Edit file: `pubspec.yaml`**

Di bagian `flutter:`, tambahkan:

```yaml
flutter:
  uses-material-design: true

  # Add .env file
  assets:
    - .env
```

#### **Langkah 4: Initialize Supabase**

**Edit file: `lib/main.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBuild();
  }
}
```

**💡 Penjelasan:**
- `WidgetsFlutterBinding.ensureInitialized()`: Required untuk async operations di main
- `dotenv.load()`: Load environment variables dari .env file
- `Supabase.initialize()`: Initialize Supabase client dengan credentials

#### **Langkah 5: Install flutter_dotenv Package**

**Edit file: `pubspec.yaml`**

```yaml
dependencies:
  flutter:
    sdk: flutter
  nylo_framework: ^6.9.1
  shared_preferences: ^2.5.3
  supabase_flutter: ^2.9.1
  flutter_dotenv: ^5.2.1  # Tambahkan ini
```

```bash
flutter pub get
```

#### **Langkah 6: Test Initialization**

**Hot restart app** (Shift + R di terminal)

Jika tidak ada error, Supabase berhasil di-initialize! 🎉

---

## 🔄 Bagian 2: Replace Storage dengan Supabase (35 menit)

### **2.1 Create SupabaseService**

**Create file: `lib/app/services/supabase_service.dart`**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '/app/models/task.dart';

class SupabaseService {
  // Get Supabase client
  final SupabaseClient supabase = Supabase.instance.client;

  // Table name
  static const String tableName = 'tasks';

  /// Fetch all tasks from Supabase
  Future<List<Task>> getTasks() async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .order('created_at', ascending: false);

      // Convert response to List<Task>
      List<Task> tasks = (response as List)
          .map((json) => Task.fromSupabaseJson(json))
          .toList();

      print('✅ Fetched ${tasks.length} tasks from Supabase');
      return tasks;
    } catch (e) {
      print('❌ Error fetching tasks: $e');
      rethrow;
    }
  }

  /// Insert new task to Supabase
  Future<Task> createTask(Task task) async {
    try {
      final response = await supabase
          .from(tableName)
          .insert(task.toSupabaseJson())
          .select()
          .single();

      Task createdTask = Task.fromSupabaseJson(response);
      print('✅ Created task in Supabase: ${createdTask.id}');
      return createdTask;
    } catch (e) {
      print('❌ Error creating task: $e');
      rethrow;
    }
  }

  /// Update existing task in Supabase
  Future<Task> updateTask(Task task) async {
    try {
      final response = await supabase
          .from(tableName)
          .update(task.toSupabaseJson())
          .eq('id', task.id)
          .select()
          .single();

      Task updatedTask = Task.fromSupabaseJson(response);
      print('✅ Updated task in Supabase: ${updatedTask.id}');
      return updatedTask;
    } catch (e) {
      print('❌ Error updating task: $e');
      rethrow;
    }
  }

  /// Delete task from Supabase
  Future<void> deleteTask(String taskId) async {
    try {
      await supabase
          .from(tableName)
          .delete()
          .eq('id', taskId);

      print('✅ Deleted task from Supabase: $taskId');
    } catch (e) {
      print('❌ Error deleting task: $e');
      rethrow;
    }
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    try {
      // Get all task IDs first
      final tasks = await getTasks();

      // Delete one by one (untuk table tanpa RLS bisa delete all sekaligus)
      for (var task in tasks) {
        await deleteTask(task.id);
      }

      print('✅ Deleted all tasks from Supabase');
    } catch (e) {
      print('❌ Error deleting all tasks: $e');
      rethrow;
    }
  }
}
```

---

### **2.2 Update Task Model untuk Supabase**

**Edit file: `lib/app/models/task.dart`**

Tambahkan methods untuk convert dari/ke Supabase format:

```dart
class Task {
  // Properties - tetap sama
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;

  // Constructor - tetap sama
  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
  });

  // Existing fromJson untuk SharedPreferences
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Existing toJson untuk SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // NEW: fromSupabaseJson - convert dari Supabase response
  factory Task.fromSupabaseJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['is_completed'] as bool? ?? false,  // Note: snake_case dari database
      createdAt: DateTime.parse(json['created_at'] as String),  // Note: snake_case
    );
  }

  // NEW: toSupabaseJson - convert ke format Supabase
  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,  // Convert ke snake_case untuk database
      'created_at': createdAt.toIso8601String(),
    };
  }

  // copyWith - tetap sama
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted)';
  }
}
```

**💡 Perbedaan Key:**
- **SharedPreferences**: `isCompleted`, `createdAt` (camelCase)
- **Supabase Database**: `is_completed`, `created_at` (snake_case)

Kita buat 2 set methods untuk handle keduanya!

---

### **2.3 Update Controller untuk Pakai Supabase**

**Edit file: `lib/app/controllers/todo_home_controller.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/task.dart';
import '/app/services/supabase_service.dart';  // Import Supabase service

class TodoHomeController extends Controller {
  // State
  List<Task> tasks = [];
  bool isLoading = false;
  String? errorMessage;

  // Supabase service (ganti dari StorageService)
  final SupabaseService supabase = SupabaseService();

  @override
  construct(BuildContext context) {
    super.construct(context);

    // Load tasks from Supabase
    loadTasksFromSupabase();
  }

  /// Load tasks from Supabase
  Future<void> loadTasksFromSupabase() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch dari Supabase
      List<Task> loadedTasks = await supabase.getTasks();

      tasks = loadedTasks;

      setState(() {
        isLoading = false;
      });

      print('✅ Loaded ${tasks.length} tasks from Supabase');
    } catch (e) {
      print('❌ Error loading tasks: $e');

      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load tasks: ${e.toString()}';
      });

      // Show error toast
      showToastNotification(
        context,
        title: 'Error',
        description: 'Failed to load tasks from cloud',
        style: ToastNotificationStyleType.DANGER,
      );
    }
  }

  /// Refresh tasks (pull-to-refresh)
  Future<void> refresh() async {
    await loadTasksFromSupabase();
  }

  // Getters
  int get totalTasks => tasks.length;
  int get completedTasks => tasks.where((t) => t.isCompleted).length;
  int get pendingTasks => tasks.where((t) => !t.isCompleted).length;

  /// Add new task to Supabase
  Future<void> addTask({
    required String title,
    String description = '',
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Create task object
      Task newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      // Insert ke Supabase
      Task createdTask = await supabase.createTask(newTask);

      // Add to local list
      tasks.insert(0, createdTask);

      setState(() {
        isLoading = false;
      });

      print('✅ Task added: $createdTask');
    } catch (e) {
      print('❌ Error adding task: $e');

      setState(() {
        isLoading = false;
      });

      showToastNotification(
        context,
        title: 'Error',
        description: 'Failed to add task',
        style: ToastNotificationStyleType.DANGER,
      );

      rethrow;
    }
  }

  /// Update task in Supabase
  Future<void> updateTask({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      final taskIndex = tasks.indexWhere((t) => t.id == id);

      if (taskIndex == -1) {
        throw Exception('Task not found');
      }

      // Create updated task
      Task updatedTask = tasks[taskIndex].copyWith(
        title: title,
        description: description,
        isCompleted: isCompleted,
      );

      // Update di Supabase
      Task savedTask = await supabase.updateTask(updatedTask);

      // Update local list
      tasks[taskIndex] = savedTask;

      setState(() {
        isLoading = false;
      });

      print('✅ Task updated: $savedTask');
    } catch (e) {
      print('❌ Error updating task: $e');

      setState(() {
        isLoading = false;
      });

      showToastNotification(
        context,
        title: 'Error',
        description: 'Failed to update task',
        style: ToastNotificationStyleType.DANGER,
      );

      rethrow;
    }
  }

  /// Toggle complete status
  Future<void> toggleComplete(String id) async {
    final taskIndex = tasks.indexWhere((t) => t.id == id);

    if (taskIndex != -1) {
      await updateTask(
        id: id,
        isCompleted: !tasks[taskIndex].isCompleted,
      );
    }
  }

  /// Delete task from Supabase
  Future<void> deleteTask(String id) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Delete dari Supabase
      await supabase.deleteTask(id);

      // Remove from local list
      tasks.removeWhere((t) => t.id == id);

      setState(() {
        isLoading = false;
      });

      print('✅ Task deleted: $id');
    } catch (e) {
      print('❌ Error deleting task: $e');

      setState(() {
        isLoading = false;
      });

      showToastNotification(
        context,
        title: 'Error',
        description: 'Failed to delete task',
        style: ToastNotificationStyleType.DANGER,
      );

      rethrow;
    }
  }

  /// Clear all tasks
  Future<void> clearAllTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      await supabase.deleteAllTasks();

      tasks.clear();

      setState(() {
        isLoading = false;
      });

      print('✅ All tasks cleared');
    } catch (e) {
      print('❌ Error clearing tasks: $e');

      setState(() {
        isLoading = false;
      });

      rethrow;
    }
  }

  // Filter methods
  List<Task> getTasksByStatus(bool isCompleted) {
    return tasks.where((t) => t.isCompleted == isCompleted).toList();
  }

  List<Task> get pendingTasksList => getTasksByStatus(false);
  List<Task> get completedTasksList => getTasksByStatus(true);
}
```

---

### **2.4 Add Loading Indicator to UI**

**Edit file: `lib/resources/pages/todo_home_page.dart`**

Update `_buildTaskList()` untuk show loading:

```dart
Widget _buildTaskList() {
  final controller = widget.controller;

  // Show loading indicator
  if (controller.isLoading && controller.tasks.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading tasks from cloud...'),
        ],
      ),
    );
  }

  // Show error message
  if (controller.errorMessage != null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Failed to load tasks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            controller.errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              controller.refresh();
            },
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<Task> tasks = controller.tasks;

  // Empty state
  if (tasks.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_done, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text(
            'No tasks yet!',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the + button to add your first task',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  return ListView.builder(
    padding: EdgeInsets.all(16),
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      final task = tasks[index];
      return _buildTaskCard(task);
    },
  );
}
```

---

## ✅ Bagian 3: Testing & Polish (25 menit)

### **3.1 Complete Testing Checklist**

Test semua operasi CRUD dengan Supabase:

**Create:**
- [ ] Add task baru
- [ ] Task muncul di app
- [ ] Check di Supabase Table Editor - task ada di database
- [ ] Close app, open lagi - task masih ada

**Read:**
- [ ] Open app - tasks load dari Supabase
- [ ] Loading indicator muncul saat fetch
- [ ] Empty state jika belum ada tasks

**Update:**
- [ ] Toggle complete task
- [ ] Status update di app
- [ ] Check di Supabase - is_completed berubah
- [ ] Refresh app - status tetap

**Delete:**
- [ ] Delete task
- [ ] Task hilang dari app
- [ ] Check di Supabase - task hilang dari database

**Multi-Device (Bonus):**
- [ ] Install app di 2 devices (atau 1 device + browser Supabase)
- [ ] Add task di device 1
- [ ] Refresh/restart app di device 2
- [ ] Task muncul di device 2! 🎉

---

### **3.2 Add Pull-to-Refresh**

**Edit file: `lib/resources/pages/todo_home_page.dart`**

Wrap ListView dengan RefreshIndicator:

```dart
@override
Widget view(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('My Todo List'),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      actions: [
        // Refresh button
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            widget.controller.refresh();
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'clear') {
              _showClearConfirmation();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.delete_sweep, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Clear All Tasks'),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
    body: Column(
      children: [
        _buildStatsCard(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => widget.controller.refresh(),
            child: _buildTaskList(),
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        routeTo('/add-task');
      },
      child: Icon(Icons.add),
    ),
  );
}
```

Now users can pull down to refresh! 🔄

---

### **3.3 Error Handling Best Practices**

Pastikan semua async operations di-wrap dengan try-catch:

```dart
// Good ✅
try {
  await supabase.createTask(newTask);
  // Success handling
} catch (e) {
  // Error handling
  showToastNotification(
    context,
    title: 'Error',
    description: 'Something went wrong',
    style: ToastNotificationStyleType.DANGER,
  );
}

// Bad ❌
await supabase.createTask(newTask); // Bisa crash kalau error!
```

---

## 🎉 Congratulations!

Aplikasi ToDo List Anda sekarang:
✅ Pakai Model class (type-safe)
✅ Data persist dengan Supabase (cloud storage)
✅ CRUD operations lengkap
✅ Multi-device sync ready
✅ Error handling proper
✅ Loading states & feedback

---

## 🚀 Next Steps (After Workshop)

### **Improvements:**
1. **Authentication**: Add user login dengan Supabase Auth
2. **RLS**: Enable Row Level Security untuk data privacy
3. **Offline Mode**: Cache data dengan Hive untuk offline-first
4. **Real-time**: Subscribe ke Supabase Realtime untuk live updates
5. **Search & Filter**: Tambah fitur search dan filter by status
6. **Categories**: Buat multiple task lists/categories
7. **Due Dates**: Tambah due date & reminders
8. **UI Polish**: Better animations, themes, dark mode

---

## 🐛 Common Issues & Solutions

### **Issue 1: "Connection refused" atau "Failed to connect"**
**Symptom**: Error saat fetch dari Supabase
**Solution**:
- Check internet connection
- Verify SUPABASE_URL dan SUPABASE_ANON_KEY di .env
- Check di Supabase Dashboard - project status = Active
- Coba access URL di browser - harus response

### **Issue 2: "Invalid API key"**
**Symptom**: 401 Unauthorized error
**Solution**:
- Copy ulang anon key dari Supabase Dashboard → Settings → API
- Pastikan tidak ada extra spaces di .env
- Restart app setelah ubah .env

### **Issue 3: "Table 'tasks' does not exist"**
**Symptom**: Error query table not found
**Solution**:
- Check di Table Editor - table `tasks` ada?
- Re-run SQL create table script
- Verify table name sama persis (case-sensitive)

### **Issue 4: "Column 'is_completed' not found"**
**Symptom**: Error query column not found
**Solution**:
- Check column names di Table Editor
- Pastikan pakai snake_case: `is_completed`, `created_at`
- Update `toSupabaseJson()` dan `fromSupabaseJson()` methods

### **Issue 5: Tasks not syncing between devices**
**Symptom**: Add di device A, tidak muncul di device B
**Solution**:
- Pastikan kedua device pakai project Supabase yang sama
- Call `refresh()` di device B untuk fetch latest data
- Check internet di kedua devices

---

## 📚 Key Takeaways

✅ **Supabase:**
- Backend-as-a-Service berbasis PostgreSQL
- Free tier generous untuk belajar & small projects
- Easy integration dengan Flutter via supabase_flutter package

✅ **Migration Path:**
- Start simple: In-memory (List)
- Then persist: SharedPreferences (local)
- Scale up: Supabase (cloud)

✅ **Best Practices:**
- Always use .env untuk credentials (jangan hardcode!)
- Add .env ke .gitignore
- Wrap async operations dengan try-catch
- Show loading states untuk better UX
- Handle errors gracefully dengan user feedback

✅ **Database Naming:**
- Dart/Flutter: camelCase (`isCompleted`)
- Database: snake_case (`is_completed`)
- Convert di Model methods: `fromSupabaseJson()` & `toSupabaseJson()`

---

## 📖 Resources

- **Supabase Docs**: https://supabase.com/docs
- **Supabase Flutter**: https://supabase.com/docs/reference/dart/introduction
- **Flutter Dotenv**: https://pub.dev/packages/flutter_dotenv
- **PostgreSQL Tutorial**: https://www.postgresqltutorial.com/

---

## 🔗 Navigation

[← Sesi 4 - Model & Data Persistence](./sesi-04.md) | [Workshop Modules](./README.md)

---

*Workshop Material - Simple ToDo List with Flutter Nylo | Dokumentasi Sesi 5 - Integrasi Supabase | Terakhir diperbarui: November 21, 2025*

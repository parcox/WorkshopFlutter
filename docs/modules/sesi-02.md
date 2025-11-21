# 📱 Sesi 2: UI & Navigation dengan Flutter

## 🎯 Overview Sesi

**Durasi**: 90 menit (1.5 jam) | **Branch**: `01-hello-nylo` → `02-home-page` → `03-add-page` → `04-detail-page` | **Tujuan**: Belajar Flutter widgets dasar dan navigasi antar halaman

---

## 📋 Agenda Sesi

### **Bagian 1: Flutter Widgets Fundamentals** (30 menit)
- [x] Pengenalan widget tree di Flutter
- [x] Widget-widget dasar: Container, Column, Row, Text, Icon
- [x] ListView untuk menampilkan list data
- [x] Card untuk container dengan shadow
- [x] Button widgets: ElevatedButton, IconButton, FloatingActionButton

### **Bagian 2: Build Home Page** (30 menit)
- [x] Generate HomePage dengan Metro CLI
- [x] Build UI list todo dengan data static
- [x] Styling cards dan layout

### **Bagian 3: Multi-Page Navigation** (30 menit)
- [x] Generate AddTaskPage dan DetailTaskPage
- [x] Setup routes di Nylo
- [x] Navigasi antar halaman dengan routeTo()
- [x] Passing data antar halaman

---

## 📱 Bagian 1: Flutter Widgets Fundamentals (30 menit)

### **1.1 Widget Tree Concept**

Flutter itu seperti menyusun balok LEGO. Setiap balok adalah **widget**, dan kita susun widget-widget ini untuk membuat tampilan aplikasi.

```
Scaffold (kerangka utama)
├── AppBar (header di atas)
├── Body
│   └── ListView (list yang bisa di-scroll)
│       ├── Card (kotak dengan shadow)
│       │   └── ListTile (baris dengan icon, text, trailing)
│       ├── Card
│       └── Card
└── FloatingActionButton (tombol bulat melayang)
```

**Analogi sederhana**:
- **Scaffold** = Rumah (kerangka utama)
- **AppBar** = Atap rumah (bagian atas)
- **Body** = Ruangan dalam rumah
- **ListView** = Rak yang bisa di-scroll
- **Card** = Kotak penyimpanan di rak

---

### **1.2 Widget-Widget Dasar**

#### **Container**
Widget paling fleksibel untuk layout. Seperti kotak yang bisa diatur ukuran, warna, padding, margin.

```dart
Container(
  width: 200,           // lebar
  height: 100,          // tinggi
  padding: EdgeInsets.all(16),  // jarak dalam
  margin: EdgeInsets.all(8),    // jarak luar
  decoration: BoxDecoration(
    color: Colors.blue,          // warna background
    borderRadius: BorderRadius.circular(12), // sudut melengkung
  ),
  child: Text('Hello'),  // isi container
)
```

**Kapan pakai Container?**
- Kalau butuh background warna
- Kalau butuh padding/margin
- Kalau butuh border radius (sudut melengkung)

---

#### **Column & Row**

**Column** = Susun widget secara **vertikal** (atas ke bawah)
**Row** = Susun widget secara **horizontal** (kiri ke kanan)

```dart
// Column - susun vertical
Column(
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
)

// Row - susun horizontal
Row(
  children: [
    Icon(Icons.star),
    Text('Rating'),
    Text('4.5'),
  ],
)
```

**Alignment**:
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,  // posisi vertikal
  crossAxisAlignment: CrossAxisAlignment.start, // posisi horizontal
  children: [...],
)
```

**Analogi**:
- `mainAxisAlignment` = Posisi sepanjang arah utama (vertikal untuk Column, horizontal untuk Row)
- `crossAxisAlignment` = Posisi tegak lurus arah utama

---

#### **ListView**

Untuk menampilkan list data yang bisa di-scroll. Ada 2 cara:

**1. ListView dengan children (untuk data sedikit/fixed):**
```dart
ListView(
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
)
```

**2. ListView.builder (untuk data banyak/dynamic):**
```dart
ListView.builder(
  itemCount: 10,  // jumlah item
  itemBuilder: (context, index) {
    // Widget yang akan dibuat untuk setiap item
    return Text('Item $index');
  },
)
```

**Kapan pakai ListView.builder?**
- Data banyak (10+ item)
- Data dari variable/list
- Performance lebih baik karena hanya build widget yang terlihat di layar

---

#### **Card**

Widget untuk membuat container dengan shadow (efek mengambang).

```dart
Card(
  elevation: 4,  // tinggi shadow (0-20)
  margin: EdgeInsets.all(8),
  child: ListTile(
    leading: Icon(Icons.check_circle),
    title: Text('Task Title'),
    subtitle: Text('Task description here'),
    trailing: Icon(Icons.more_vert),
  ),
)
```

**Kombinasi Card + ListTile** sangat umum untuk membuat list item yang rapi!

---

#### **Button Widgets**

**1. ElevatedButton** - Button dengan shadow dan background warna:
```dart
ElevatedButton(
  onPressed: () {
    print('Button diklik!');
  },
  child: Text('Save'),
)
```

**2. IconButton** - Button berbentuk icon saja:
```dart
IconButton(
  icon: Icon(Icons.delete),
  onPressed: () {
    print('Delete clicked');
  },
)
```

**3. FloatingActionButton** - Button bulat yang melayang (biasa di kanan bawah):
```dart
FloatingActionButton(
  onPressed: () {
    print('FAB clicked');
  },
  child: Icon(Icons.add),
)
```

---

#### **TextField**

Widget untuk input text dari user.

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Task Title',
    hintText: 'Enter task title here',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.edit),
  ),
  onChanged: (value) {
    print('User ketik: $value');
  },
)
```

**Properties penting:**
- `labelText` = Label yang muncul di atas
- `hintText` = Placeholder text abu-abu
- `border` = Border style
- `onChanged` = Function yang dipanggil setiap kali user ketik

---

### **1.3 Hands-on: Coba Widget Dasar**

Mari coba modifikasi `home_page.dart` bawaan Nylo untuk eksplorasi widgets.

**Langkah 1: Buka file home_page.dart**

```bash
# Path: lib/resources/pages/home_page.dart
```

**Langkah 2: Ganti body dengan widget experiments:**

```dart
// lib/resources/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/home_controller.dart';

class HomePage extends NyStatefulWidget<HomeController> {
  static RouteView path = ("/home", (_) => HomePage());

  HomePage({super.key}) : super(child: () => _HomePageState());
}

class _HomePageState extends NyState<HomePage> {
  @override
  init() async {
    super.init();
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget Playground'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Container example
          _buildContainerExample(),
          SizedBox(height: 16),

          // Row example
          _buildRowExample(),
          SizedBox(height: 16),

          // Card example
          _buildCardExample(),
          SizedBox(height: 16),

          // TextField example
          _buildTextFieldExample(),
        ],
      ),
    );
  }

  Widget _buildContainerExample() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Ini Container dengan background biru',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildRowExample() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(Icons.star, color: Colors.orange, size: 32),
        Icon(Icons.favorite, color: Colors.red, size: 32),
        Icon(Icons.thumb_up, color: Colors.blue, size: 32),
      ],
    );
  }

  Widget _buildCardExample() {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.check),
        ),
        title: Text('Contoh Card + ListTile'),
        subtitle: Text('Ini subtitle'),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildTextFieldExample() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Coba ketik di sini',
        hintText: 'Placeholder text',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.edit),
      ),
    );
  }
}
```

**Langkah 3: Run aplikasi dan lihat hasilnya!**

```bash
flutter run
```

**💡 Coba-coba sendiri:**
- Ganti warna background Container
- Tambah icon baru di Row
- Ubah text di Card
- Tambahkan `suffixIcon` di TextField

**📸 Screenshot:**
Ambil screenshot hasil percobaan Anda dan bandingkan dengan teman!

---

## 🏠 Bagian 2: Build Home Page ToDo List (30 menit)

Sekarang kita akan membuat halaman utama aplikasi ToDo List dengan data static (hardcode dulu).

### **2.1 Generate HomePage Baru**

```bash
# Generate page baru untuk todo list
dart run nylo_framework:main make:page todo_home_page
```

**Output:**
```
✓ Created lib/resources/pages/todo_home_page.dart
✓ Created lib/app/controllers/todo_home_controller.dart
```

---

### **2.2 Setup Route untuk TodoHomePage**

**Edit file: `lib/routes/router.dart`**

```dart
import 'package:nylo_framework/nylo_framework.dart';
import '/resources/pages/home_page.dart';
import '/resources/pages/todo_home_page.dart';

appRouter() => nyRoutes((router) {
  router.add(HomePage.path);

  // Route baru untuk todo home
  router.add(TodoHomePage.path);
});
```

---

### **2.3 Update Main App untuk Start di TodoHomePage**

**Edit file: `lib/app/providers/route_provider.dart`**

Cari bagian `initialRoute` dan ganti ke `/todo-home`:

```dart
// lib/app/providers/route_provider.dart
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RouteProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {
    NyNavigator.instance.router = nylo.router;

    // Ubah initial route ke todo home page
    NyNavigator.instance.initialRoute = '/todo-home';  // <-- UBAH INI
  }
}
```

---

### **2.4 Build TodoHomePage UI**

**Edit file: `lib/resources/pages/todo_home_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/todo_home_controller.dart';

class TodoHomePage extends NyStatefulWidget<TodoHomeController> {
  static RouteView path = ("/todo-home", (_) => TodoHomePage());

  TodoHomePage({super.key}) : super(child: () => _TodoHomePageState());
}

class _TodoHomePageState extends NyState<TodoHomePage> {
  @override
  init() async {
    super.init();
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Todo List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Nanti akan navigate ke Add Task Page
          print('FAB diklik!');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList() {
    // Data static untuk sementara (hardcode)
    List<Map<String, dynamic>> tasks = [
      {
        'id': '1',
        'title': 'Belajar Flutter',
        'description': 'Selesaikan tutorial Flutter basics',
        'isCompleted': false,
      },
      {
        'id': '2',
        'title': 'Setup Project Nylo',
        'description': 'Install dan setup Nylo framework',
        'isCompleted': true,
      },
      {
        'id': '3',
        'title': 'Build ToDo App',
        'description': 'Buat aplikasi ToDo sederhana',
        'isCompleted': false,
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    bool isCompleted = task['isCompleted'] ?? false;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        // Icon di kiri
        leading: CircleAvatar(
          backgroundColor: isCompleted ? Colors.green : Colors.orange,
          child: Icon(
            isCompleted ? Icons.check : Icons.circle_outlined,
            color: Colors.white,
          ),
        ),

        // Title & description
        title: Text(
          task['title'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            // Coret text jika sudah selesai
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task['description'],
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),

        // Icon di kanan
        trailing: Icon(Icons.arrow_forward_ios, size: 16),

        // Action ketika card diklik
        onTap: () {
          print('Task "${task['title']}" diklik!');
          // TODO: Nanti akan navigate ke Detail Page
        },
      ),
    );
  }
}
```

**🔥 Run aplikasi dan lihat hasilnya!**

```bash
flutter run
# atau tekan R di terminal untuk hot reload
```

**📋 Checklist:**
- [ ] Muncul AppBar dengan title "My Todo List"
- [ ] Ada 3 task cards di list
- [ ] Task ke-2 sudah selesai (icon hijau, text coret)
- [ ] FAB (tombol +) muncul di kanan bawah
- [ ] Ketika card diklik, muncul print di console

---

### **2.5 Improve UI dengan Styling**

Mari tambahkan sedikit styling agar lebih menarik!

**Tambahkan section stats di atas list:**

```dart
@override
Widget view(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('My Todo List'),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    body: Column(
      children: [
        _buildStatsCard(),  // <-- Tambah stats card
        Expanded(child: _buildTaskList()),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        print('FAB diklik!');
      },
      child: Icon(Icons.add),
    ),
  );
}

Widget _buildStatsCard() {
  // Hitung dari data static
  int totalTasks = 3;
  int completedTasks = 1;
  int pendingTasks = 2;

  return Container(
    margin: EdgeInsets.all(16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Total', totalTasks, Colors.blue),
        _buildStatItem('Done', completedTasks, Colors.green),
        _buildStatItem('Pending', pendingTasks, Colors.orange),
      ],
    ),
  );
}

Widget _buildStatItem(String label, int count, Color color) {
  return Column(
    children: [
      Text(
        count.toString(),
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
      ),
    ],
  );
}
```

**Hot reload dan lihat stats card muncul di atas list!**

---

## 🚀 Bagian 3: Multi-Page Navigation (30 menit)

Sekarang kita akan buat 2 halaman baru:
1. **AddTaskPage** - Form untuk tambah task baru
2. **DetailTaskPage** - Detail task yang diklik

### **3.1 Generate AddTaskPage**

```bash
dart run nylo_framework:main make:page add_task_page
```

**Output:**
```
✓ Created lib/resources/pages/add_task_page.dart
✓ Created lib/app/controllers/add_task_controller.dart
```

---

### **3.2 Build AddTaskPage UI**

**Edit file: `lib/resources/pages/add_task_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/add_task_controller.dart';

class AddTaskPage extends NyStatefulWidget<AddTaskController> {
  static RouteView path = ("/add-task", (_) => AddTaskPage());

  AddTaskPage({super.key}) : super(child: () => _AddTaskPageState());
}

class _AddTaskPageState extends NyState<AddTaskPage> {
  // Controller untuk TextField
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    // Bersihkan controller saat page ditutup
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title input
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                hintText: 'e.g. Belajar Flutter',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            SizedBox(height: 16),

            // Description input
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Describe your task here...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Save Task',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    // Validasi
    if (title.isEmpty) {
      // Show error message
      showToastNotification(
        context,
        title: 'Error',
        description: 'Task title tidak boleh kosong!',
        style: ToastNotificationStyleType.DANGER,
      );
      return;
    }

    // Print untuk testing (nanti akan save ke storage)
    print('Saving task:');
    print('Title: $title');
    print('Description: $description');

    // Show success message
    showToastNotification(
      context,
      title: 'Success',
      description: 'Task berhasil ditambahkan!',
      style: ToastNotificationStyleType.SUCCESS,
    );

    // Kembali ke halaman sebelumnya setelah 1 detik
    Future.delayed(Duration(seconds: 1), () {
      pop(context);
    });
  }
}
```

---

### **3.3 Generate DetailTaskPage**

```bash
dart run nylo_framework:main make:page detail_task_page
```

---

### **3.4 Build DetailTaskPage UI**

**Edit file: `lib/resources/pages/detail_task_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/detail_task_controller.dart';

class DetailTaskPage extends NyStatefulWidget<DetailTaskController> {
  static RouteView path = ("/detail-task", (_) => DetailTaskPage());

  DetailTaskPage({super.key}) : super(child: () => _DetailTaskPageState());
}

class _DetailTaskPageState extends NyState<DetailTaskPage> {
  // Data task yang diterima dari halaman sebelumnya
  Map<String, dynamic>? task;

  @override
  init() async {
    super.init();
    // Ambil data task dari route arguments
    task = widget.data();
  }

  @override
  Widget view(BuildContext context) {
    // Jika task null, tampilkan error
    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Task not found')),
      );
    }

    bool isCompleted = task!['isCompleted'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print('Edit button diklik');
              // TODO: Navigate ke edit page
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              print('Delete button diklik');
              // TODO: Implement delete
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.pending,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Title
            Text(
              'Title',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              task!['title'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Description
            Text(
              'Description',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              task!['description'] ?? 'No description',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),

            // Toggle complete button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  print('Toggle complete: ${!isCompleted}');
                  // TODO: Update task status
                },
                icon: Icon(isCompleted ? Icons.undo : Icons.check),
                label: Text(
                  isCompleted ? 'Mark as Pending' : 'Mark as Completed',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### **3.5 Setup Routes**

**Edit file: `lib/routes/router.dart`**

```dart
import 'package:nylo_framework/nylo_framework.dart';
import '/resources/pages/home_page.dart';
import '/resources/pages/todo_home_page.dart';
import '/resources/pages/add_task_page.dart';
import '/resources/pages/detail_task_page.dart';

appRouter() => nyRoutes((router) {
  router.add(HomePage.path);
  router.add(TodoHomePage.path);
  router.add(AddTaskPage.path);
  router.add(DetailTaskPage.path);
});
```

---

### **3.6 Implement Navigation dari TodoHomePage**

Sekarang kita hubungkan semua halaman dengan navigasi!

**Edit file: `lib/resources/pages/todo_home_page.dart`**

**Update FAB action:**

```dart
floatingActionButton: FloatingActionButton(
  onPressed: () {
    // Navigate ke Add Task Page
    routeTo('/add-task');
  },
  child: Icon(Icons.add),
),
```

**Update onTap di task card:**

```dart
Widget _buildTaskCard(Map<String, dynamic> task) {
  bool isCompleted = task['isCompleted'] ?? false;

  return Card(
    elevation: 2,
    margin: EdgeInsets.only(bottom: 12),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: isCompleted ? Colors.green : Colors.orange,
        child: Icon(
          isCompleted ? Icons.check : Icons.circle_outlined,
          color: Colors.white,
        ),
      ),
      title: Text(
        task['title'],
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        task['description'],
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigate ke Detail Page dengan passing data
        routeTo(
          '/detail-task',
          data: task,  // <-- Pass task data ke halaman detail
        );
      },
    ),
  );
}
```

---

### **3.7 Testing Navigation**

**Test flow:**

1. **Run aplikasi**
   ```bash
   flutter run
   ```

2. **Test FAB Navigation:**
   - Klik tombol + (FAB)
   - Harus masuk ke Add Task Page
   - Isi form dan klik Save
   - Harus kembali ke Home Page dengan toast success

3. **Test Card Navigation:**
   - Klik salah satu task card di home
   - Harus masuk ke Detail Task Page
   - Lihat detail task muncul
   - Klik back button untuk kembali

**📋 Checklist:**
- [ ] FAB navigate ke Add Task Page
- [ ] Form validation bekerja (title wajib diisi)
- [ ] Toast notification muncul saat save
- [ ] Otomatis kembali ke home setelah save
- [ ] Card navigate ke Detail Page dengan data yang benar
- [ ] Detail page menampilkan title, description, dan status
- [ ] Back button berfungsi di semua halaman

---

## 🎨 Bonus: Custom App Theme

Mari buat aplikasi lebih konsisten dengan custom theme!

**Edit file: `lib/config/theme.dart`**

```dart
import 'package:flutter/material.dart';

ThemeData getAppTheme() {
  return ThemeData(
    // Primary color
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,

    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    ),

    // FloatingActionButton theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),

    // Card theme
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    ),

    // Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
```

**Terapkan theme di MaterialApp:**

**Edit file: `lib/app/providers/app_provider.dart`**

Cari bagian `boot` method dan pastikan theme sudah di-load:

```dart
@override
boot(Nylo nylo) async {
  nylo.addThemes([
    ThemeData.light(), // light theme
    ThemeData.dark(),  // dark theme
    getAppTheme(),     // custom app theme
  ]);

  nylo.themeId = 2; // Set ke index 2 (custom theme)

  return nylo;
}
```

**Hot reload dan lihat perubahan styling di seluruh aplikasi!**

---

## 🎯 Latihan Mandiri

### **Latihan 1: Empty State**
Tambahkan empty state di `TodoHomePage` ketika list tasks kosong.

**Hint:**
```dart
if (tasks.isEmpty) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text('No tasks yet!'),
        Text('Tap + button to add your first task'),
      ],
    ),
  );
}
```

### **Latihan 2: Search Bar**
Tambahkan search bar di AppBar untuk filter tasks.

**Hint:**
- Gunakan `TextField` di AppBar
- Filter tasks dengan `tasks.where((t) => t['title'].contains(query))`

### **Latihan 3: Confirmation Dialog**
Tambahkan dialog konfirmasi sebelum delete di Detail Page.

**Hint:**
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Delete Task?'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(onPressed: () => pop(context), child: Text('Cancel')),
      TextButton(onPressed: () {
        // Delete logic
        pop(context);
      }, child: Text('Delete')),
    ],
  ),
);
```

---

## 🐛 Common Issues & Solutions

### **Issue 1: "Navigator operation requested with a context that does not include a Navigator"**
**Symptom**: Error saat panggil `routeTo()`
**Solution**:
- Pastikan `appRouter()` sudah didaftarkan di `RouteProvider`
- Pastikan semua pages sudah di-add di `router.dart`
- Gunakan `context` dari `build()` method, bukan dari class level

### **Issue 2: "data() returns null"**
**Symptom**: Data tidak sampai ke halaman tujuan
**Solution**:
- Pastikan pass data dengan parameter `data:` di `routeTo()`
- Panggil `widget.data()` di `init()` method, bukan di `build()`

### **Issue 3: "Hot reload not working"**
**Symptom**: Perubahan kode tidak muncul di app
**Solution**:
- Coba tekan R di terminal untuk hot reload
- Jika tidak berhasil, tekan Shift+R untuk hot restart
- Last resort: Stop app dan `flutter run` ulang

### **Issue 4: "TextField not clearing after submit"**
**Symptom**: TextField masih berisi text setelah save
**Solution**:
```dart
titleController.clear();
descriptionController.clear();
```

---

## 📚 Key Takeaways

✅ **Flutter Widgets:**
- Flutter itu widget tree - semua adalah widget
- `Scaffold` kerangka dasar page (AppBar + Body + FAB)
- `ListView.builder` untuk list dinamis
- `Card` + `ListTile` kombinasi umum untuk list items
- `TextField` untuk input dari user

✅ **Navigation di Nylo:**
- Generate page dengan `metro make:page`
- Daftarkan route di `router.dart`
- Navigate dengan `routeTo('/path')`
- Pass data dengan `routeTo('/path', data: {...})`
- Terima data dengan `widget.data()`

✅ **Best Practices:**
- Pisahkan widget besar jadi method kecil (`_buildXxx()`)
- Gunakan `TextEditingController` untuk TextField
- Jangan lupa `dispose()` controller
- Validasi input sebelum process
- Berikan feedback ke user (toast, dialog)

---

## 📖 Resources

- **Flutter Widgets Catalog**: https://docs.flutter.dev/ui/widgets
- **Material Design Guidelines**: https://m3.material.io/
- **Nylo Routing**: https://nylo.dev/docs/6.x/router
- **Flutter Layout Cheatsheet**: https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e

---

## 🔗 Navigation

[← Sesi 1 - Hello Flutter with Nylo](./sesi-01.md) | [Sesi 3 - State Management & Local Data →](./sesi-03.md)

---

*Workshop Material - Simple ToDo List with Flutter Nylo | Dokumentasi Sesi 2 - UI & Navigation | Terakhir diperbarui: November 21, 2025*

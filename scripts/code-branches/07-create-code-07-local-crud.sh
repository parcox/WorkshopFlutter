#!/bin/zsh

# ============================================
# Workshop Flutter - Create Branch code-07-local-crud
# ============================================
# Branch: code-07-local-crud
# Deskripsi: In-memory CRUD operations (Create, Read, Update, Delete)
# Sesi: 3 (State Management) - Bagian 2 (Complete)

# Load base functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/00-setup-base.sh"

# ============================================
# Main Script
# ============================================

print_header "Create Branch: code-07-local-crud"

# Step 1: Check prerequisites
if ! check_prerequisites; then
    exit 1
fi

# Step 2: Clone Nylo (if not already done)
if [[ ! -d "$TEMP_DIR" ]]; then
    if ! clone_nylo_to_temp; then
        exit 1
    fi

    if ! test_flutter_setup; then
        cleanup_temp
        exit 1
    fi
else
    print_step "SKIP" "Nylo already cloned to temp (reusing)"
    echo ""
fi

# Step 3: Create branch from previous
print_step "BRANCH" "Creating code-07-local-crud..."
echo ""

cd "$REPO_DIR"
print_info "Checking out code-06-controller as base..."
git checkout code-06-controller 2>/dev/null

print_info "Creating new branch code-07-local-crud..."
git checkout -b code-07-local-crud 2>/dev/null

# Step 4: Update TodoHomeController with CRUD methods
print_info "Adding CRUD methods to TodoHomeController..."

cat > lib/app/controllers/todo_home_controller.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class TodoHomeController extends Controller {
  // List untuk menyimpan tasks (in-memory)
  List<Map<String, dynamic>> tasks = [];

  @override
  construct(BuildContext context) {
    super.construct(context);

    // Initialize with sample data
    tasks = [
      {
        'id': '1',
        'title': 'Belajar Flutter',
        'description': 'Ikuti workshop Flutter dengan Nylo framework',
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '2',
        'title': 'Setup Supabase',
        'description': 'Create project dan database di Supabase',
        'isCompleted': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': '3',
        'title': 'Build ToDo App',
        'description': 'Implementasi CRUD operations',
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];
  }

  // ============================================
  // READ Operations
  // ============================================

  /// Helper getters untuk stats
  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((t) => t['isCompleted'] == true).length;

  int get pendingTasks => tasks.where((t) => t['isCompleted'] == false).length;

  /// Get tasks by status
  List<Map<String, dynamic>> getTasksByStatus(bool isCompleted) {
    return tasks.where((t) => t['isCompleted'] == isCompleted).toList();
  }

  /// Get pending tasks only
  List<Map<String, dynamic>> get pendingTasksList => getTasksByStatus(false);

  /// Get completed tasks only
  List<Map<String, dynamic>> get completedTasksList => getTasksByStatus(true);

  // ============================================
  // CREATE Operation
  // ============================================

  /// Add new task
  void addTask({
    required String title,
    String description = '',
  }) {
    // Generate simple ID (nanti akan pakai UUID atau dari database)
    String newId = DateTime.now().millisecondsSinceEpoch.toString();

    // Create task object
    Map<String, dynamic> newTask = {
      'id': newId,
      'title': title,
      'description': description,
      'isCompleted': false,
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Add to list (insert di awal)
    tasks.insert(0, newTask);

    // Update UI
    setState(() {});

    print('✓ Task added: $title');
  }

  // ============================================
  // UPDATE Operations
  // ============================================

  /// Update task
  void updateTask({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    // Cari task by id
    final taskIndex = tasks.indexWhere((t) => t['id'] == id);

    if (taskIndex == -1) {
      print('✗ Task not found: $id');
      return;
    }

    // Update properties jika ada
    if (title != null) {
      tasks[taskIndex]['title'] = title;
    }

    if (description != null) {
      tasks[taskIndex]['description'] = description;
    }

    if (isCompleted != null) {
      tasks[taskIndex]['isCompleted'] = isCompleted;
    }

    // Update UI
    setState(() {});

    print('✓ Task updated: $id');
  }

  /// Toggle complete status (shortcut)
  void toggleComplete(String id) {
    final taskIndex = tasks.indexWhere((t) => t['id'] == id);

    if (taskIndex != -1) {
      bool currentStatus = tasks[taskIndex]['isCompleted'] ?? false;
      tasks[taskIndex]['isCompleted'] = !currentStatus;
      setState(() {});
      print('✓ Task toggled: $id -> ${!currentStatus}');
    }
  }

  // ============================================
  // DELETE Operation
  // ============================================

  /// Delete task
  void deleteTask(String id) {
    // Remove from list
    tasks.removeWhere((t) => t['id'] == id);

    // Update UI
    setState(() {});

    print('✓ Task deleted: $id');
  }

  /// Delete all completed tasks
  void deleteCompletedTasks() {
    tasks.removeWhere((t) => t['isCompleted'] == true);
    setState(() {});
    print('✓ All completed tasks deleted');
  }
}
EOF

# Update AddTaskPage to call addTask
cat > lib/resources/pages/add_task_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/todo_home_controller.dart';

class AddTaskPage extends StatefulWidget {
  static const path = '/add-task';

  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'e.g. Belajar Flutter',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Describe your task here...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
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

    if (title.isEmpty) {
      showToastNotification(
        context,
        title: 'Error',
        description: 'Task title tidak boleh kosong!',
        style: ToastNotificationStyleType.danger,
      );
      return;
    }

    // Get TodoHomeController
    final homeController = NYC.controller<TodoHomeController>();

    // Call addTask method
    homeController.addTask(
      title: title,
      description: description,
    );

    // Show success message
    showToastNotification(
      context,
      title: 'Success',
      description: 'Task berhasil ditambahkan!',
      style: ToastNotificationStyleType.success,
    );

    // Kembali ke home
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
EOF

# Update DetailTaskPage with toggle and delete
cat > lib/resources/pages/detail_task_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/todo_home_controller.dart';

class DetailTaskPage extends StatefulWidget {
  static const path = '/detail-task';

  const DetailTaskPage({super.key});

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  Map<String, dynamic>? task;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        setState(() {
          task = args;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Detail'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    bool isCompleted = task!['isCompleted'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showToastNotification(
                context,
                title: "Edit",
                description: "Edit feature akan dibuat di sesi berikutnya",
                style: ToastNotificationStyleType.info,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  const SizedBox(width: 4),
                  Text(
                    isCompleted ? 'Completed' : 'Pending',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task!['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task!['description'] ?? 'No description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _handleToggle,
                icon: Icon(isCompleted ? Icons.undo : Icons.check),
                label: Text(
                  isCompleted ? 'Mark as Pending' : 'Mark as Completed',
                  style: const TextStyle(fontSize: 16),
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

  void _handleToggle() {
    if (task == null) return;

    final controller = NYC.controller<TodoHomeController>();
    bool isCompleted = task!['isCompleted'] ?? false;

    controller.toggleComplete(task!['id']);

    setState(() {
      task!['isCompleted'] = !isCompleted;
    });

    showToastNotification(
      context,
      title: 'Success',
      description: isCompleted ? 'Task marked as pending' : 'Task marked as completed',
      style: ToastNotificationStyleType.success,
    );
  }

  void _handleDelete() {
    if (task == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final controller = NYC.controller<TodoHomeController>();
              controller.deleteTask(task!['id']);

              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to home

              showToastNotification(
                context,
                title: 'Deleted',
                description: 'Task deleted successfully',
                style: ToastNotificationStyleType.success,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
EOF

print_success "CRUD operations implemented"

# Step 5: Commit and push
echo ""
commit_message="code: Sesi 3 completed - In-memory CRUD operations

- CREATE: addTask() method working
- READ: getters & filters (all, completed, pending)
- UPDATE: updateTask() & toggleComplete()
- DELETE: deleteTask() with confirmation dialog
- AddTaskPage now saves to controller
- DetailTaskPage now toggle & delete working
- setState() updates UI automatically
- Full in-memory CRUD completed!
- Ready untuk data persistence (Sesi 4)"

if ! commit_and_push_branch "code-07-local-crud" "$commit_message"; then
    echo ""
    print_error "Failed to push branch"
    echo "  You can push manually later:"
    echo "  git push origin code-07-local-crud"
fi

# Step 6: Return to main
echo ""
return_to_main

# Summary
echo ""
print_header "✓ Branch code-07-local-crud Created!"
echo ""
echo "Branch: ${GREEN}code-07-local-crud${NC}"
echo "Status: Sesi 3 completed - Full CRUD working!"
echo ""
echo "${BLUE}Test locally:${NC}"
echo "  git checkout code-07-local-crud"
echo "  flutter run"
echo ""
echo "${CYAN}CRUD Operations:${NC}"
echo "  ✓ CREATE: Add new task via AddTaskPage"
echo "  ✓ READ: Display all tasks, filter by status"
echo "  ✓ UPDATE: Toggle complete status"
echo "  ✓ DELETE: Delete task with confirmation"
echo ""
echo "${GREEN}Sesi 3 Completed!${NC}"
echo "  ✓ TodoHomeController with state management"
echo "  ✓ In-memory CRUD operations"
echo "  ✓ UI updates automatically (setState)"
echo "  ✓ Data centralized in controller"
echo ""
echo "${YELLOW}Next:${NC}"
echo "  Sesi 4: Model & Data Persistence"
echo "  Branch 08-10: Task model, SharedPreferences, persistent data"
echo ""

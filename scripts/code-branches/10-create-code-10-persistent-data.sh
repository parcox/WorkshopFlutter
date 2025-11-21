#!/bin/zsh
#############################################################################
# Branch: code-10-persistent-data
# Sesi 4 - Bagian 3: Persistent CRUD
#
# Tujuan:
# - Update semua CRUD methods untuk auto-save ke storage
# - Implement persistent Create, Read, Update, Delete
# - Test data persistence (survive app restart)
# - Make AddTaskPage save async
#
# Prerequisites:
# - Branch code-09-shared-preferences sudah dibuat
# - Shared functions dari 00-setup-base.sh tersedia
#############################################################################

# Source shared functions
SCRIPT_DIR="${0:a:h}"
source "$SCRIPT_DIR/00-setup-base.sh"

# Configuration
BRANCH_NAME="code-10-persistent-data"
PREV_BRANCH="code-09-shared-preferences"
COMMIT_MESSAGE="Sesi 4 Part 3: Make all CRUD operations persistent"

echo "${BLUE}========================================${NC}"
echo "${BLUE}  Creating Branch: $BRANCH_NAME${NC}"
echo "${BLUE}========================================${NC}"
echo ""

# 1. Check prerequisites
check_prerequisites

# 2. Checkout previous branch
echo "${CYAN}📌 Checking out branch: $PREV_BRANCH${NC}"
git checkout "$PREV_BRANCH"
if [ $? -ne 0 ]; then
  echo "${RED}❌ Failed to checkout branch: $PREV_BRANCH${NC}"
  exit 1
fi
echo "${GREEN}✓ Checked out $PREV_BRANCH${NC}"
echo ""

# 3. Create new orphan branch
create_orphan_branch "$BRANCH_NAME"

# 4. Update TodoHomeController with persistent CRUD
echo "${CYAN}📝 Updating TodoHomeController with persistent CRUD...${NC}"

cat > "lib/app/controllers/todo_home_controller.dart" << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/task.dart';
import '/app/services/storage_service.dart';

class TodoHomeController extends Controller {
  // State
  List<Task> tasks = [];
  bool isLoading = false;

  // Storage service
  final StorageService storage = StorageService();

  @override
  construct(BuildContext context) {
    super.construct(context);

    // Load tasks from storage saat pertama kali
    loadTasksFromStorage();
  }

  // Load tasks from storage
  Future<void> loadTasksFromStorage() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load dari storage
      List<Task> loadedTasks = await storage.loadTasks();

      // Jika storage kosong, pakai sample data
      if (loadedTasks.isEmpty) {
        tasks = [
          Task(
            id: '1',
            title: 'Belajar Flutter',
            description: 'Selesaikan tutorial Flutter basics',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
          Task(
            id: '2',
            title: 'Setup Project Nylo',
            description: 'Install dan setup Nylo framework',
            isCompleted: true,
            createdAt: DateTime.now(),
          ),
          Task(
            id: '3',
            title: 'Build ToDo App',
            description: 'Buat aplikasi ToDo sederhana',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
        ];

        // Save sample data ke storage
        await storage.saveTasks(tasks);
      } else {
        tasks = loadedTasks;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading tasks: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save tasks to storage
  Future<void> saveTasksToStorage() async {
    await storage.saveTasks(tasks);
  }

  // Helper getters
  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((t) => t.isCompleted).length;

  int get pendingTasks => tasks.where((t) => !t.isCompleted).length;

  // Create: Add new task (NOW WITH AUTO-SAVE!)
  Future<void> addTask({
    required String title,
    String description = '',
  }) async {
    String newId = DateTime.now().millisecondsSinceEpoch.toString();

    Task newTask = Task(
      id: newId,
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    tasks.insert(0, newTask);

    // Save ke storage
    await saveTasksToStorage();

    setState(() {});
    print('Task added and saved: $newTask');
  }

  // Update: Modify existing task (NOW WITH AUTO-SAVE!)
  Future<void> updateTask({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    final taskIndex = tasks.indexWhere((t) => t.id == id);

    if (taskIndex == -1) {
      print('Task not found: $id');
      return;
    }

    tasks[taskIndex] = tasks[taskIndex].copyWith(
      title: title,
      description: description,
      isCompleted: isCompleted,
    );

    // Save ke storage
    await saveTasksToStorage();

    setState(() {});
    print('Task updated and saved: ${tasks[taskIndex]}');
  }

  // Toggle task completion status (NOW WITH AUTO-SAVE!)
  Future<void> toggleComplete(String id) async {
    final taskIndex = tasks.indexWhere((t) => t.id == id);

    if (taskIndex != -1) {
      tasks[taskIndex] = tasks[taskIndex].copyWith(
        isCompleted: !tasks[taskIndex].isCompleted,
      );

      // Save ke storage
      await saveTasksToStorage();

      setState(() {});
    }
  }

  // Delete: Remove task (NOW WITH AUTO-SAVE!)
  Future<void> deleteTask(String id) async {
    tasks.removeWhere((t) => t.id == id);

    // Save ke storage
    await saveTasksToStorage();

    setState(() {});
    print('Task deleted and saved');
  }

  // Clear all tasks
  Future<void> clearAllTasks() async {
    tasks.clear();
    await storage.clearTasks();
    setState(() {});
    print('All tasks cleared');
  }

  // Delete all completed tasks (NOW WITH AUTO-SAVE!)
  Future<void> deleteCompletedTasks() async {
    tasks.removeWhere((t) => t.isCompleted);
    await saveTasksToStorage();
    setState(() {});
    print('Completed tasks deleted and saved');
  }

  // Filter methods
  List<Task> getTasksByStatus(bool isCompleted) {
    return tasks.where((t) => t.isCompleted == isCompleted).toList();
  }

  List<Task> get pendingTasksList => getTasksByStatus(false);
  List<Task> get completedTasksList => getTasksByStatus(true);
}
EOF

echo "${GREEN}✓ TodoHomeController updated with persistent CRUD${NC}"
echo ""

# 5. Update AddTaskPage to use async save
echo "${CYAN}📝 Updating AddTaskPage for async save...${NC}"

cat > "lib/resources/pages/add_task_page.dart" << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/todo_home_controller.dart';

class AddTaskPage extends NyStatefulWidget {
  static const path = '/add-task';

  AddTaskPage({super.key}) : super(child: () => _AddTaskPageState());
}

class _AddTaskPageState extends NyState<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isSaving = false;

  @override
  void dispose() {
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
            // Title field
            Text(
              'Task Title *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 24),

            // Description field
            Text(
              'Description (Optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter task description',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 4,
            ),
            SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: isSaving
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
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

  Future<void> _handleSave() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isEmpty) {
      showToastNotification(
        context,
        title: "Error",
        description: "Task title tidak boleh kosong!",
        icon: Icons.error,
        style: ToastNotificationStyleType.DANGER,
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final homeController = NYC.controller<TodoHomeController>();

    try {
      // Call addTask method (sekarang async!)
      await homeController.addTask(
        title: title,
        description: description,
      );

      showToastNotification(
        context,
        title: "Success",
        description: "Task berhasil ditambahkan dan disimpan!",
        icon: Icons.check_circle,
        style: ToastNotificationStyleType.SUCCESS,
      );

      // Wait a bit before popping
      await Future.delayed(Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving task: $e');

      showToastNotification(
        context,
        title: "Error",
        description: "Gagal menyimpan task!",
        icon: Icons.error,
        style: ToastNotificationStyleType.DANGER,
      );

      setState(() {
        isSaving = false;
      });
    }
  }
}
EOF

echo "${GREEN}✓ AddTaskPage updated for async save${NC}"
echo ""

# 6. Update DetailTaskPage to use async operations
echo "${CYAN}📝 Updating DetailTaskPage for async operations...${NC}"

cat > "lib/resources/pages/detail_task_page.dart" << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/todo_home_controller.dart';
import '/app/models/task.dart';

class DetailTaskPage extends NyStatefulWidget {
  static const path = '/detail-task';

  DetailTaskPage({super.key}) : super(child: () => _DetailTaskPageState());
}

class _DetailTaskPageState extends NyState<DetailTaskPage> {
  Task? task;
  bool isProcessing = false;

  @override
  init() async {
    super.init();

    // Ambil data dari route arguments
    final taskData = widget.data() as Map<String, dynamic>?;

    if (taskData != null) {
      // Convert Map ke Task object
      task = Task.fromJson(taskData);
    }
  }

  @override
  Widget view(BuildContext context) {
    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Task not found')),
      );
    }

    bool isCompleted = task!.isCompleted;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showToastNotification(
                context,
                title: "Info",
                description: "Edit feature coming soon!",
                icon: Icons.edit,
                style: ToastNotificationStyleType.INFO,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: isProcessing ? null : () {
              _showDeleteConfirmation();
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
                color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCompleted ? Colors.green : Colors.orange,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.pending,
                    size: 16,
                    color: isCompleted ? Colors.green : Colors.orange,
                  ),
                  SizedBox(width: 4),
                  Text(
                    isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(
                      color: isCompleted ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Title section
            Text(
              'Title',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              task!.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),

            // Description section
            Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              task!.description.isEmpty ? 'No description' : task!.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),

            // Toggle status button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isProcessing ? null : _toggleTaskStatus,
                icon: isProcessing
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        isCompleted ? Icons.refresh : Icons.check,
                        color: Colors.white,
                      ),
                label: Text(
                  isCompleted ? 'Mark as Pending' : 'Mark as Completed',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.orange : Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  disabledBackgroundColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleTaskStatus() async {
    if (task == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      final controller = NYC.controller<TodoHomeController>();
      await controller.toggleComplete(task!.id);

      // Update local state
      setState(() {
        task = task!.copyWith(isCompleted: !task!.isCompleted);
        isProcessing = false;
      });

      showToastNotification(
        context,
        title: "Success",
        description: "Task status updated and saved!",
        icon: Icons.check_circle,
        style: ToastNotificationStyleType.SUCCESS,
      );
    } catch (e) {
      print('Error toggling task: $e');

      setState(() {
        isProcessing = false;
      });

      showToastNotification(
        context,
        title: "Error",
        description: "Failed to update task status!",
        icon: Icons.error,
        style: ToastNotificationStyleType.DANGER,
      );
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTask();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask() async {
    if (task == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      final controller = NYC.controller<TodoHomeController>();
      await controller.deleteTask(task!.id);

      showToastNotification(
        context,
        title: "Success",
        description: "Task deleted and saved!",
        icon: Icons.delete,
        style: ToastNotificationStyleType.SUCCESS,
      );

      await Future.delayed(Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error deleting task: $e');

      setState(() {
        isProcessing = false;
      });

      showToastNotification(
        context,
        title: "Error",
        description: "Failed to delete task!",
        icon: Icons.error,
        style: ToastNotificationStyleType.DANGER,
      );
    }
  }
}
EOF

echo "${GREEN}✓ DetailTaskPage updated for async operations${NC}"
echo ""

# 7. Test Flutter setup
test_flutter_setup

# 8. Commit and push
commit_and_push_branch "$BRANCH_NAME" "$COMMIT_MESSAGE"

# 9. Return to main
return_to_main

echo ""
echo "${GREEN}========================================${NC}"
echo "${GREEN}  ✓ Branch $BRANCH_NAME created!${NC}"
echo "${GREEN}========================================${NC}"
echo ""
echo "${YELLOW}What changed in this branch:${NC}"
echo "  1. ✅ addTask() now async with auto-save to storage"
echo "  2. ✅ updateTask() now async with auto-save to storage"
echo "  3. ✅ toggleComplete() now async with auto-save to storage"
echo "  4. ✅ deleteTask() now async with auto-save to storage"
echo "  5. ✅ AddTaskPage shows loading indicator while saving"
echo "  6. ✅ DetailTaskPage shows loading indicator during operations"
echo "  7. ✅ Error handling for all async operations"
echo "  8. 🎉 Data now persists after app restart!"
echo ""
echo "${CYAN}Test persistence:${NC}"
echo "  1. Add new task → Close app → Reopen → Task masih ada!"
echo "  2. Toggle status → Close app → Reopen → Status tetap!"
echo "  3. Delete task → Close app → Reopen → Task hilang!"
echo ""
echo "${GREEN}✓ Sesi 4 completed! (Model & Data Persistence)${NC}"
echo ""
echo "${CYAN}Next: Branch code-11 (Sesi 5: Supabase Integration)${NC}"
echo ""

#!/bin/zsh
#############################################################################
# Branch: code-09-shared-preferences
# Sesi 4 - Bagian 2: SharedPreferences Setup
#
# Tujuan:
# - Install shared_preferences package
# - Create StorageService untuk handle save/load data
# - Implement JSON encoding/decoding
# - Add persistence foundation (belum full CRUD integration)
#
# Prerequisites:
# - Branch code-08-task-model sudah dibuat
# - Shared functions dari 00-setup-base.sh tersedia
#############################################################################

# Source shared functions
SCRIPT_DIR="${0:a:h}"
source "$SCRIPT_DIR/00-setup-base.sh"

# Configuration
BRANCH_NAME="code-09-shared-preferences"
PREV_BRANCH="code-08-task-model"
COMMIT_MESSAGE="Sesi 4 Part 2: Add SharedPreferences for data persistence"

echo "${BLUE}========================================${NC}"
echo "${BLUE}  Creating Branch: $BRANCH_NAME${NC}"
echo "${BLUE}========================================${NC}"
echo ""

# 1. Check prerequisites
check_prerequisites

# 2. Create new orphan branch from previous branch (preserves all files)
create_orphan_branch_from_prev "$BRANCH_NAME" "$PREV_BRANCH"

# 4. Update pubspec.yaml to add shared_preferences
echo "${CYAN}📝 Adding shared_preferences to pubspec.yaml...${NC}"

cat > "pubspec.yaml" << 'EOF'
name: simple_todo_app
description: "A simple todo application built with Nylo framework"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.5.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  nylo_framework: ^6.9.1
  shared_preferences: ^2.5.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
EOF

echo "${GREEN}✓ pubspec.yaml updated with shared_preferences${NC}"
echo ""

# 5. Create StorageService
echo "${CYAN}📝 Creating StorageService...${NC}"

# Create services directory if not exists
mkdir -p "lib/app/services"

cat > "lib/app/services/storage_service.dart" << 'EOF'
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/app/models/task.dart';

class StorageService {
  // Storage key
  static const String tasksKey = 'tasks';

  // Get SharedPreferences instance
  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  /// Save tasks to storage
  Future<bool> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await _prefs;

      // Convert List<Task> ke List<Map>
      List<Map<String, dynamic>> tasksJson =
        tasks.map((task) => task.toJson()).toList();

      // Convert List<Map> ke JSON string
      String tasksString = jsonEncode(tasksJson);

      // Save ke SharedPreferences
      bool result = await prefs.setString(tasksKey, tasksString);

      print('✅ Saved ${tasks.length} tasks to storage');
      return result;
    } catch (e) {
      print('❌ Error saving tasks: $e');
      return false;
    }
  }

  /// Load tasks from storage
  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await _prefs;

      // Get JSON string dari SharedPreferences
      String? tasksString = prefs.getString(tasksKey);

      // Jika null, return empty list
      if (tasksString == null || tasksString.isEmpty) {
        print('ℹ️ No tasks in storage');
        return [];
      }

      // Convert JSON string ke List<dynamic>
      List<dynamic> tasksJson = jsonDecode(tasksString);

      // Convert List<dynamic> ke List<Task>
      List<Task> tasks = tasksJson
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();

      print('✅ Loaded ${tasks.length} tasks from storage');
      return tasks;
    } catch (e) {
      print('❌ Error loading tasks: $e');
      return [];
    }
  }

  /// Clear all tasks from storage
  Future<bool> clearTasks() async {
    try {
      final prefs = await _prefs;
      bool result = await prefs.remove(tasksKey);

      print('✅ Cleared tasks from storage');
      return result;
    } catch (e) {
      print('❌ Error clearing tasks: $e');
      return false;
    }
  }

  /// Check if tasks exist in storage
  Future<bool> hasTasks() async {
    final prefs = await _prefs;
    return prefs.containsKey(tasksKey);
  }
}
EOF

echo "${GREEN}✓ StorageService created${NC}"
echo ""

# 6. Update TodoHomeController with storage (basic integration)
echo "${CYAN}📝 Updating TodoHomeController with StorageService...${NC}"

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

  // Create: Add new task (belum save to storage - akan di branch 10)
  void addTask({
    required String title,
    String description = '',
  }) {
    String newId = DateTime.now().millisecondsSinceEpoch.toString();

    Task newTask = Task(
      id: newId,
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    tasks.insert(0, newTask);
    setState(() {});

    print('Task added: $newTask');
    print('⚠️ Note: Task belum auto-save ke storage (akan ditambahkan di branch 10)');
  }

  // Update: Modify existing task (belum save to storage - akan di branch 10)
  void updateTask({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
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

    setState(() {});
    print('Task updated: ${tasks[taskIndex]}');
    print('⚠️ Note: Task belum auto-save ke storage (akan ditambahkan di branch 10)');
  }

  // Toggle task completion status (belum save to storage - akan di branch 10)
  void toggleComplete(String id) {
    final taskIndex = tasks.indexWhere((t) => t.id == id);

    if (taskIndex != -1) {
      tasks[taskIndex] = tasks[taskIndex].copyWith(
        isCompleted: !tasks[taskIndex].isCompleted,
      );
      setState(() {});
      print('⚠️ Note: Task belum auto-save ke storage (akan ditambahkan di branch 10)');
    }
  }

  // Delete: Remove task (belum save to storage - akan di branch 10)
  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    setState(() {});
    print('Task deleted: $id');
    print('⚠️ Note: Task belum auto-save ke storage (akan ditambahkan di branch 10)');
  }

  // Clear all tasks
  Future<void> clearAllTasks() async {
    tasks.clear();
    await storage.clearTasks();
    setState(() {});
    print('All tasks cleared');
  }

  // Delete all completed tasks
  void deleteCompletedTasks() {
    tasks.removeWhere((t) => t.isCompleted);
    setState(() {});
    print('⚠️ Note: Task belum auto-save ke storage (akan ditambahkan di branch 10)');
  }

  // Filter methods
  List<Task> getTasksByStatus(bool isCompleted) {
    return tasks.where((t) => t.isCompleted == isCompleted).toList();
  }

  List<Task> get pendingTasksList => getTasksByStatus(false);
  List<Task> get completedTasksList => getTasksByStatus(true);
}
EOF

echo "${GREEN}✓ TodoHomeController updated with storage foundation${NC}"
echo ""

# 7. Add loading indicator to HomePage
echo "${CYAN}📝 Adding loading indicator to HomePage...${NC}"

cat > "lib/resources/pages/todo_home_page.dart" << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/todo_home_controller.dart';
import '/app/models/task.dart';

class TodoHomePage extends NyStatefulWidget<TodoHomeController> {
  static const path = '/home';

  TodoHomePage({super.key}) : super(child: () => _TodoHomePageState());
}

class _TodoHomePageState extends NyState<TodoHomePage> {
  @override
  Widget view(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      appBar: AppBar(
        title: Text('Simple ToDo App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
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
      body: controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStatsCard(controller),
                Expanded(child: _buildTaskList()),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          routeTo('/add-task');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStatsCard(TodoHomeController controller) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', controller.totalTasks, Colors.blue),
          _buildStatItem('Done', controller.completedTasks, Colors.green),
          _buildStatItem('Pending', controller.pendingTasks, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    final controller = widget.controller;
    List<Task> tasks = controller.tasks;

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey.shade300),
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

  Widget _buildTaskCard(Task task) {
    bool isCompleted = task.isCompleted;

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
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task.description,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          routeTo(
            '/detail-task',
            data: task.toJson(),
          );
        },
      ),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Tasks?'),
        content: Text('This will delete all tasks permanently. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final controller = widget.controller;
              await controller.clearAllTasks();

              Navigator.pop(context);

              showToastNotification(
                context,
                title: "Cleared",
                description: "All tasks have been deleted",
                icon: Icons.delete_sweep,
                style: ToastNotificationStyleType.WARNING,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
EOF

echo "${GREEN}✓ HomePage updated with loading indicator and clear menu${NC}"
echo ""

# 8. Test Flutter setup
test_flutter_setup

# 9. Commit and push
commit_and_push_branch "$BRANCH_NAME" "$COMMIT_MESSAGE"

# 10. Return to main
return_to_main

echo ""
echo "${GREEN}========================================${NC}"
echo "${GREEN}  ✓ Branch $BRANCH_NAME created!${NC}"
echo "${GREEN}========================================${NC}"
echo ""
echo "${YELLOW}What changed in this branch:${NC}"
echo "  1. ✅ shared_preferences package added to pubspec.yaml"
echo "  2. ✅ StorageService class with save/load/clear methods"
echo "  3. ✅ JSON encoding/decoding (List<Task> ↔ JSON string)"
echo "  4. ✅ loadTasksFromStorage() on app start"
echo "  5. ✅ Loading indicator while loading data"
echo "  6. ✅ Clear All Tasks menu in AppBar"
echo "  7. ⚠️  CRUD methods belum auto-save (akan di branch 10)"
echo ""
echo "${CYAN}Next step: Branch code-10-persistent-data (make CRUD persistent)${NC}"
echo ""

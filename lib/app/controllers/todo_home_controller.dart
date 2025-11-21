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

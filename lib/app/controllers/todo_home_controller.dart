import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/task.dart';
import '/app/services/supabase_service.dart';

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
    }
  }

  /// Refresh tasks (pull-to-refresh)
  Future<void> refresh() async {
    await loadTasksFromSupabase();
  }

  // Helper getters
  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((t) => t.isCompleted).length;

  int get pendingTasks => tasks.where((t) => !t.isCompleted).length;

  /// Add new task to Supabase
  Future<void> addTask({
    required String title,
    String description = '',
  }) async {
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

      setState(() {});

      print('✅ Task added to Supabase: $createdTask');
    } catch (e) {
      print('❌ Error adding task: $e');
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

      setState(() {});

      print('✅ Task updated in Supabase: $savedTask');
    } catch (e) {
      print('❌ Error updating task: $e');
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
    try {
      // Delete dari Supabase
      await supabase.deleteTask(id);

      // Remove from local list
      tasks.removeWhere((t) => t.id == id);

      setState(() {});

      print('✅ Task deleted from Supabase: $id');
    } catch (e) {
      print('❌ Error deleting task: $e');
      rethrow;
    }
  }

  /// Clear all tasks
  Future<void> clearAllTasks() async {
    try {
      await supabase.deleteAllTasks();

      tasks.clear();

      setState(() {});

      print('✅ All tasks cleared from Supabase');
    } catch (e) {
      print('❌ Error clearing tasks: $e');
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

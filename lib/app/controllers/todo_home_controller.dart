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

import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/task.dart';

class TodoHomeController extends Controller {
  // State: List tasks dengan Task model (bukan Map lagi!)
  List<Task> tasks = [];

  @override
  construct(BuildContext context) {
    super.construct(context);

    // Initialize with sample data using Task model
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
  }

  // Helper getters
  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((t) => t.isCompleted).length;

  int get pendingTasks => tasks.where((t) => !t.isCompleted).length;

  // Create: Add new task
  void addTask({
    required String title,
    String description = '',
  }) {
    String newId = DateTime.now().millisecondsSinceEpoch.toString();

    // Create Task object (bukan Map lagi!)
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
  }

  // Update: Modify existing task
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

    // Pakai copyWith untuk update
    tasks[taskIndex] = tasks[taskIndex].copyWith(
      title: title,
      description: description,
      isCompleted: isCompleted,
    );

    setState(() {});
    print('Task updated: ${tasks[taskIndex]}');
  }

  // Toggle task completion status
  void toggleComplete(String id) {
    final taskIndex = tasks.indexWhere((t) => t.id == id);

    if (taskIndex != -1) {
      tasks[taskIndex] = tasks[taskIndex].copyWith(
        isCompleted: !tasks[taskIndex].isCompleted,
      );
      setState(() {});
    }
  }

  // Delete: Remove task
  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    setState(() {});
    print('Task deleted: $id');
  }

  // Delete all completed tasks
  void deleteCompletedTasks() {
    tasks.removeWhere((t) => t.isCompleted);
    setState(() {});
  }

  // Filter methods
  List<Task> getTasksByStatus(bool isCompleted) {
    return tasks.where((t) => t.isCompleted == isCompleted).toList();
  }

  List<Task> get pendingTasksList => getTasksByStatus(false);
  List<Task> get completedTasksList => getTasksByStatus(true);
}

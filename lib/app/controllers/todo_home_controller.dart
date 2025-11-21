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
        'createdAt': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
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

  // Helper getters untuk stats
  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((t) => t['isCompleted'] == true).length;

  int get pendingTasks => tasks.where((t) => t['isCompleted'] == false).length;

  // CRUD methods akan ditambahkan di branch berikutnya
}

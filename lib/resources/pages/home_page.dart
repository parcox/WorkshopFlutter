import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class HomePage extends StatefulWidget {
  static const path = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data static (hardcoded)
  final List<Map<String, dynamic>> tasks = [
    {
      'id': '1',
      'title': 'Belajar Flutter',
      'description': 'Ikuti workshop Flutter dengan Nylo framework',
      'isCompleted': false,
      'createdAt': '2025-11-20',
    },
    {
      'id': '2',
      'title': 'Setup Supabase',
      'description': 'Create project dan database di Supabase',
      'isCompleted': true,
      'createdAt': '2025-11-19',
    },
    {
      'id': '3',
      'title': 'Build ToDo App',
      'description': 'Implementasi CRUD operations',
      'isCompleted': false,
      'createdAt': '2025-11-21',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildStatsCard(),
          Expanded(child: _buildTaskList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate ke Add Task Page
          routeTo('/add-task');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsCard() {
    int totalTasks = tasks.length;
    int completedTasks = tasks.where((t) => t['isCompleted'] == true).length;
    int pendingTasks = totalTasks - completedTasks;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
        const SizedBox(height: 4),
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

  Widget _buildTaskList() {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada task',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      margin: const EdgeInsets.only(bottom: 12),
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
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          showToastNotification(
            context,
            title: "Task: ${task['title']}",
            description: "Detail page akan dibuat di branch berikutnya",
            style: ToastNotificationStyleType.info,
          );
        },
      ),
    );
  }
}

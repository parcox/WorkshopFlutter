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

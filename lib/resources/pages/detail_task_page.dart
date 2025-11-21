import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/todo_home_controller.dart';
import '/app/models/task.dart';

class DetailTaskPage extends NyStatefulWidget {
  static const path = '/detail-task';

  DetailTaskPage({super.key}) : super(child: () => _DetailTaskPageState());
}

class _DetailTaskPageState extends NyState<DetailTaskPage> {
  Task? task;  // Ubah dari Map ke Task

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

    bool isCompleted = task!.isCompleted;  // Akses property langsung

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
            onPressed: () {
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
              task!.title,  // Akses property langsung
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
                onPressed: () {
                  _toggleTaskStatus();
                },
                icon: Icon(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTaskStatus() {
    if (task == null) return;

    final controller = NYC.controller<TodoHomeController>();
    controller.toggleComplete(task!.id);  // Akses property langsung

    // Update local state
    setState(() {
      task = task!.copyWith(isCompleted: !task!.isCompleted);
    });

    showToastNotification(
      context,
      title: "Success",
      description: "Task status updated!",
      icon: Icons.check_circle,
      style: ToastNotificationStyleType.SUCCESS,
    );
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

  void _deleteTask() {
    if (task == null) return;

    final controller = NYC.controller<TodoHomeController>();
    controller.deleteTask(task!.id);  // Akses property langsung

    showToastNotification(
      context,
      title: "Success",
      description: "Task deleted successfully!",
      icon: Icons.delete,
      style: ToastNotificationStyleType.SUCCESS,
    );

    Navigator.pop(context);
  }
}

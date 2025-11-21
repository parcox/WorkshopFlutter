import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AddTaskPage extends StatefulWidget {
  static const path = '/add-task';

  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  // Controller untuk TextField
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    // Bersihkan controller saat page ditutup
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title input
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'e.g. Belajar Flutter',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),

            // Description input
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Describe your task here...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
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

  void _handleSave() {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    // Validasi
    if (title.isEmpty) {
      // Show error message
      showToastNotification(
        context,
        title: 'Error',
        description: 'Task title tidak boleh kosong!',
        style: ToastNotificationStyleType.danger,
      );
      return;
    }

    // Print untuk testing (nanti akan save ke controller)
    print('Saving task:');
    print('Title: $title');
    print('Description: $description');

    // Show success message
    showToastNotification(
      context,
      title: 'Success',
      description: 'Task berhasil ditambahkan!',
      style: ToastNotificationStyleType.success,
    );

    // Kembali ke halaman sebelumnya setelah 1 detik
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}

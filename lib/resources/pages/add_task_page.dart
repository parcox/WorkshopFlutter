import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTaskPage extends NyStatefulWidget {
  static const path = '/add-task';

  AddTaskPage({super.key}) : super(child: () => _AddTaskPageState());
}

class _AddTaskPageState extends NyState<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isSaving = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            Text(
              'Task Title *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 24),

            // Description field
            Text(
              'Description (Optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter task description',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 4,
            ),
            SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: isSaving
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
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

  Future<void> _handleSave() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isEmpty) {
      showToastNotification(
        context,
        title: "Error",
        description: "Task title tidak boleh kosong!",
        icon: Icons.error,
        style: ToastNotificationStyleType.danger,
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      // Create new task directly with Supabase
      // Generate ID using timestamp (same as controller)
      final taskId = DateTime.now().millisecondsSinceEpoch.toString();

      await Supabase.instance.client.from('tasks').insert({
        'id': taskId,
        'title': title,
        'description': description,
        'is_completed': false,
        'created_at': DateTime.now().toIso8601String(),
      });

      showToastNotification(
        context,
        title: "Success",
        description: "Task berhasil ditambahkan dan disimpan!",
        icon: Icons.check_circle,
        style: ToastNotificationStyleType.success,
      );

      // Wait a bit before popping
      await Future.delayed(Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate task was added
      }
    } catch (e) {
      print('Error saving task: $e');

      showToastNotification(
        context,
        title: "Error",
        description: "Gagal menyimpan task!",
        icon: Icons.error,
        style: ToastNotificationStyleType.danger,
      );

      setState(() {
        isSaving = false;
      });
    }
  }
}

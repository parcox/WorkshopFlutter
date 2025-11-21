import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/app/models/task.dart';

class DetailTaskPage extends NyStatefulWidget {
  static const path = '/detail-task';

  DetailTaskPage({super.key}) : super(child: () => _DetailTaskPageState());
}

class _DetailTaskPageState extends NyState<DetailTaskPage> {
  Task? task;
  bool isProcessing = false;
  bool hasChanges = false; // Track if task was modified
  bool isEditMode = false; // Track if in edit mode

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  initState() {
    super.initState();
    _initializeTask();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _initializeTask() {
    final taskData = widget.data() as Map<String, dynamic>?;

    if (taskData != null) {
      task = Task.fromJson(taskData);
      titleController.text = task!.title;
      descriptionController.text = task!.description;
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

    bool isCompleted = task!.isCompleted;
    String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(task!.createdAt);
    String formattedTime = DateFormat('h:mm a').format(task!.createdAt);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Handle back button - return hasChanges flag
          Navigator.pop(context, hasChanges);
        }
      },
      child: Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, hasChanges);
            },
          ),
        title: Text('Task Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
            if (isEditMode)
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  // Cancel edit mode
                  setState(() {
                    isEditMode = false;
                    titleController.text = task!.title;
                    descriptionController.text = task!.description;
                  });
                },
              )
            else
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    isEditMode = true;
                  });
                },
              ),
            if (!isEditMode)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: isProcessing
                    ? null
                    : () {
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isCompleted
                    ? [Colors.green.shade400, Colors.green.shade600]
                    : [Colors.orange.shade400, Colors.orange.shade600],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (isCompleted ? Colors.green : Colors.orange).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.pending,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8),
              if (isEditMode)
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter task title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                )
              else
                Text(
                  task!.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
            SizedBox(height: 24),

            // Description section
            Text(
              'Description',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8),
              if (isEditMode)
                TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter task description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    task!.description.isEmpty
                        ? 'No description provided'
                        : task!.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: task!.description.isEmpty
                          ? Colors.grey
                          : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
            SizedBox(height: 24),

            // Created date section
            Text(
              'Created',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  formattedTime,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
            SizedBox(height: 32),

              // Action buttons - either Save/Cancel for edit mode or Toggle status for view mode
              if (isEditMode)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isProcessing ? null : _saveChanges,
                        icon: isProcessing
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.save, color: Colors.white),
                        label: Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                )
              else
                // Toggle status button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: isProcessing ? null : _toggleTaskStatus,
                    icon: isProcessing
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            isCompleted ? Icons.refresh : Icons.check,
                            color: Colors.white,
                          ),
                    label: Text(
                      isCompleted ? 'Mark as Pending' : 'Mark as Completed',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCompleted ? Colors.orange : Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
          ],
        ),
      ),
      ), // Close PopScope
    );
  }

  Future<void> _saveChanges() async {
    if (task == null) return;

    final newTitle = titleController.text.trim();
    final newDescription = descriptionController.text.trim();

    if (newTitle.isEmpty) {
      showToastNotification(
        context,
        title: "Error",
        description: "Task title cannot be empty!",
        icon: Icons.error,
        style: ToastNotificationStyleType.danger,
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      // Update task in Supabase
      await Supabase.instance.client.from('tasks').update({
        'title': newTitle,
        'description': newDescription,
      }).eq('id', task!.id);

      setState(() {
        task = task!.copyWith(
          title: newTitle,
          description: newDescription,
        );
        isProcessing = false;
        isEditMode = false;
        hasChanges = true;
      });

      showToastNotification(
        context,
        title: "Success",
        description: "Task updated successfully!",
        icon: Icons.check_circle,
        style: ToastNotificationStyleType.success,
      );
    } catch (e) {
      print('Error updating task: $e');

      setState(() {
        isProcessing = false;
      });

      showToastNotification(
        context,
        title: "Error",
        description: "Failed to update task!",
        icon: Icons.error,
        style: ToastNotificationStyleType.danger,
      );
    }
  }

  Future<void> _toggleTaskStatus() async {
    if (task == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      // Update task status directly with Supabase
      final newStatus = !task!.isCompleted;
      await Supabase.instance.client
          .from('tasks')
          .update({'is_completed': newStatus}).eq('id', task!.id);

      setState(() {
        task = task!.copyWith(isCompleted: newStatus);
        isProcessing = false;
        hasChanges = true; // Mark that task was modified
      });

      showToastNotification(
        context,
        title: "Success",
        description: "Task status updated and saved to cloud!",
        icon: Icons.check_circle,
        style: ToastNotificationStyleType.success,
      );
    } catch (e) {
      print('Error toggling task: $e');

      setState(() {
        isProcessing = false;
      });

      showToastNotification(
        context,
        title: "Error",
        description: "Failed to update task status!",
        icon: Icons.error,
        style: ToastNotificationStyleType.danger,
      );
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Delete Task?'),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${task!.title}"?\n\n'
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTask();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask() async {
    if (task == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      // Delete task directly with Supabase
      await Supabase.instance.client.from('tasks').delete().eq('id', task!.id);

      showToastNotification(
        context,
        title: "Success",
        description: "Task deleted and saved to cloud!",
        icon: Icons.delete,
        style: ToastNotificationStyleType.success,
      );

      await Future.delayed(Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(
            context, true); // Return true to indicate task was deleted
      }
    } catch (e) {
      print('Error deleting task: $e');

      setState(() {
        isProcessing = false;
      });

      showToastNotification(
        context,
        title: "Error",
        description: "Failed to delete task!",
        icon: Icons.error,
        style: ToastNotificationStyleType.danger,
      );
    }
  }
}

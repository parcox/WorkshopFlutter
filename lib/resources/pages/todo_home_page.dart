import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/todo_home_controller.dart';
import '/app/models/task.dart';

class TodoHomePage extends NyStatefulWidget<TodoHomeController> {
  static const path = '/home';

  TodoHomePage({super.key}) : super(child: () => _TodoHomePageState());
}

class _TodoHomePageState extends NyState<TodoHomePage> {
  @override
  Widget view(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Simple ToDo App'),
            Text(
              '☁️ Cloud Sync',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Refresh button
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.refresh();
            },
            tooltip: 'Refresh from cloud',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmation();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear All Tasks'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection status banner
          if (controller.errorMessage != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  Icon(Icons.cloud_off, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Connection error. Pull down to retry.',
                      style: TextStyle(fontSize: 12, color: Colors.red.shade900),
                    ),
                  ),
                ],
              ),
            ),
          _buildStatsCard(controller),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.refresh(),
              child: _buildTaskList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          routeTo('/add-task');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Add new task',
      ),
    );
  }

  Widget _buildStatsCard(TodoHomeController controller) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', controller.totalTasks, Colors.blue),
          _buildStatItem('Done', controller.completedTasks, Colors.green),
          _buildStatItem('Pending', controller.pendingTasks, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    final controller = widget.controller;

    // Show loading indicator
    if (controller.isLoading && controller.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading tasks from cloud...'),
            SizedBox(height: 8),
            Text(
              'Please wait',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Show error message (if no tasks loaded)
    if (controller.errorMessage != null && controller.tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Connection Error',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'Failed to connect to cloud database',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              SizedBox(height: 8),
              Text(
                controller.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  controller.refresh();
                },
                icon: Icon(Icons.refresh),
                label: Text('Retry Connection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Troubleshooting tips:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Check internet connection\n'
                '• Verify .env file configuration\n'
                '• Ensure Supabase project is active',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      );
    }

    List<Task> tasks = controller.tasks;

    // Empty state
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_done, size: 80, color: Colors.green.shade200),
            SizedBox(height: 16),
            Text(
              'No tasks yet!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first task',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_done, size: 16, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Connected to cloud',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Task list
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    bool isCompleted = task.isCompleted;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted ? Colors.green : Colors.orange,
          child: Icon(
            isCompleted ? Icons.check : Icons.circle_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description.isNotEmpty
            ? Text(
                task.description,
                style: TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          routeTo(
            '/detail-task',
            data: task.toJson(),
          );
        },
      ),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Tasks?'),
        content: Text(
          'This will permanently delete all tasks from the cloud database. '
          'This action cannot be undone.\n\nAre you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final controller = widget.controller;

              try {
                await controller.clearAllTasks();

                showToastNotification(
                  context,
                  title: "Success",
                  description: "All tasks have been deleted from cloud",
                  icon: Icons.delete_sweep,
                  style: ToastNotificationStyleType.SUCCESS,
                );
              } catch (e) {
                showToastNotification(
                  context,
                  title: "Error",
                  description: "Failed to clear tasks: ${e.toString()}",
                  icon: Icons.error,
                  style: ToastNotificationStyleType.DANGER,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete All'),
          ),
        ],
      ),
    );
  }
}

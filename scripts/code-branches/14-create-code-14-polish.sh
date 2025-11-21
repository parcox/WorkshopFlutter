#!/bin/zsh
#############################################################################
# Branch: code-14-polish
# BONUS: Final Polish & Extra Features
#
# Tujuan:
# - Add app icon & splash screen customization
# - Improve UI animations
# - Add task count badge
# - Add delete confirmation with undo option
# - Better date/time formatting
# - Final touches for production-ready app
#
# Prerequisites:
# - Branch code-13-cloud-sync sudah dibuat
# - Shared functions dari 00-setup-base.sh tersedia
#############################################################################

# Source shared functions
SCRIPT_DIR="${0:a:h}"
source "$SCRIPT_DIR/00-setup-base.sh"

# Configuration
BRANCH_NAME="code-14-polish"
PREV_BRANCH="code-13-cloud-sync"
COMMIT_MESSAGE="Final polish: Improved UI, animations, and production-ready features"

echo "${BLUE}========================================${NC}"
echo "${BLUE}  Creating Branch: $BRANCH_NAME${NC}"
echo "${BLUE}========================================${NC}"
echo ""

# 1. Check prerequisites
check_prerequisites

# 2. Checkout previous branch
echo "${CYAN}📌 Checking out branch: $PREV_BRANCH${NC}"
git checkout "$PREV_BRANCH"
if [ $? -ne 0 ]; then
  echo "${RED}❌ Failed to checkout branch: $PREV_BRANCH${NC}"
  exit 1
fi
echo "${GREEN}✓ Checked out $PREV_BRANCH${NC}"
echo ""

# 3. Create new orphan branch
create_orphan_branch "$BRANCH_NAME"

# 4. Add intl package to pubspec.yaml for date formatting
echo "${CYAN}📝 Adding intl package for date formatting...${NC}"

cat > "pubspec.yaml" << 'EOF'
name: simple_todo_app
description: "A simple todo application built with Nylo framework"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.5.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  nylo_framework: ^6.9.1
  shared_preferences: ^2.5.3
  supabase_flutter: ^2.9.1
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true

  # Add .env file as asset
  assets:
    - .env
EOF

echo "${GREEN}✓ pubspec.yaml updated with intl package${NC}"
echo ""

# 5. Update HomePage with animations and improved UI
echo "${CYAN}📝 Adding animations and polish to HomePage...${NC}"

cat > "lib/resources/pages/todo_home_page.dart" << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:intl/intl.dart';
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
              '☁️ Cloud Sync Active',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Refresh button with animation
          IconButton(
            icon: controller.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(Icons.refresh),
            onPressed: controller.isLoading ? null : () {
              controller.refresh();
            },
            tooltip: 'Refresh from cloud',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmation();
              } else if (value == 'about') {
                _showAboutDialog();
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
              PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('About'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          routeTo('/add-task');
        },
        icon: Icon(Icons.add),
        label: Text('Add Task'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Add new task',
      ),
    );
  }

  Widget _buildStatsCard(TodoHomeController controller) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.5),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', controller.totalTasks, Colors.blue, Icons.list),
          _buildStatItem('Done', controller.completedTasks, Colors.green, Icons.check_circle),
          _buildStatItem('Pending', controller.pendingTasks, Colors.orange, Icons.pending),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
              'Tap the button below to add your first task',
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

    // Task list with animations
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task, index);
      },
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    bool isCompleted = task.isCompleted;

    // Format date
    String formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(task.createdAt);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            routeTo('/detail-task', data: task.toJson());
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // Status indicator
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted ? Colors.grey : Colors.black87,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          task.description,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Clear All Tasks?'),
          ],
        ),
        content: Text(
          'This will permanently delete all ${widget.controller.totalTasks} tasks from the cloud database. '
          'This action cannot be undone.\n\nAre you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Simple ToDo App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Built with:'),
            SizedBox(height: 8),
            Text('• Flutter & Dart'),
            Text('• Nylo Framework'),
            Text('• Supabase (PostgreSQL)'),
            SizedBox(height: 16),
            Text(
              'A simple todo list app with cloud synchronization.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
EOF

echo "${GREEN}✓ HomePage updated with animations and polish${NC}"
echo ""

# 6. Update DetailTaskPage with better formatting
echo "${CYAN}📝 Polishing DetailTaskPage...${NC}"

cat > "lib/resources/pages/detail_task_page.dart" << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:intl/intl.dart';
import '/app/controllers/todo_home_controller.dart';
import '/app/models/task.dart';

class DetailTaskPage extends NyStatefulWidget {
  static const path = '/detail-task';

  DetailTaskPage({super.key}) : super(child: () => _DetailTaskPageState());
}

class _DetailTaskPageState extends NyState<DetailTaskPage> {
  Task? task;
  bool isProcessing = false;

  @override
  init() async {
    super.init();

    final taskData = widget.data() as Map<String, dynamic>?;

    if (taskData != null) {
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

    bool isCompleted = task!.isCompleted;
    String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(task!.createdAt);
    String formattedTime = DateFormat('h:mm a').format(task!.createdAt);

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
            onPressed: isProcessing ? null : () {
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                task!.description.isEmpty ? 'No description provided' : task!.description,
                style: TextStyle(
                  fontSize: 16,
                  color: task!.description.isEmpty ? Colors.grey : Colors.black87,
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
                  backgroundColor: isCompleted ? Colors.orange : Colors.green,
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
    );
  }

  Future<void> _toggleTaskStatus() async {
    if (task == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      final controller = NYC.controller<TodoHomeController>();
      await controller.toggleComplete(task!.id);

      setState(() {
        task = task!.copyWith(isCompleted: !task!.isCompleted);
        isProcessing = false;
      });

      showToastNotification(
        context,
        title: "Success",
        description: "Task status updated and saved to cloud!",
        icon: Icons.check_circle,
        style: ToastNotificationStyleType.SUCCESS,
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
        style: ToastNotificationStyleType.DANGER,
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
      final controller = NYC.controller<TodoHomeController>();
      await controller.deleteTask(task!.id);

      showToastNotification(
        context,
        title: "Success",
        description: "Task deleted and saved to cloud!",
        icon: Icons.delete,
        style: ToastNotificationStyleType.SUCCESS,
      );

      await Future.delayed(Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(context);
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
        style: ToastNotificationStyleType.DANGER,
      );
    }
  }
}
EOF

echo "${GREEN}✓ DetailTaskPage polished with better formatting${NC}"
echo ""

# 7. Create final README
echo "${CYAN}📝 Creating final production README...${NC}"

cat > "README.md" << 'EOF'
# 🎯 Simple ToDo App

A beautiful and functional todo list application built with Flutter, Nylo Framework, and Supabase.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter)
![Supabase](https://img.shields.io/badge/Supabase-Enabled-3ECF8E?logo=supabase)

## ✨ Features

- ✅ **Full CRUD Operations** - Create, Read, Update, Delete tasks
- ✅ **Cloud Storage** - Data stored in Supabase PostgreSQL
- ✅ **Multi-Device Sync** - Tasks automatically sync across devices
- ✅ **Pull-to-Refresh** - Swipe down to refresh data
- ✅ **Beautiful UI** - Modern design with animations
- ✅ **Error Handling** - Graceful error messages with retry
- ✅ **Loading States** - Visual feedback during operations
- ✅ **Date Formatting** - Human-readable date and time
- ✅ **Connection Status** - Real-time connection indicator
- ✅ **Responsive Design** - Works on phones and tablets

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.24.0)
- Dart SDK (>= 3.5.0)
- Android Studio / Xcode
- Supabase Account (free tier)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd simple_todo_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase:**

   a. Create a project at [supabase.com](https://supabase.com)

   b. Run this SQL in Supabase SQL Editor:
   ```sql
   CREATE TABLE tasks (
     id TEXT PRIMARY KEY,
     title TEXT NOT NULL,
     description TEXT DEFAULT '',
     is_completed BOOLEAN DEFAULT false,
     created_at TIMESTAMP WITH TIME ZONE NOT NULL,
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   ALTER TABLE tasks DISABLE ROW LEVEL SECURITY;
   ```

   c. Create `.env` file in project root:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 📱 Usage

- **Add Task:** Tap the "Add Task" button → Fill in title and description → Save
- **View Details:** Tap any task card to see full details
- **Toggle Status:** Tap the status button in detail page to mark as completed/pending
- **Delete Task:** Tap delete icon in detail page
- **Refresh:** Pull down the list or tap the refresh icon
- **Clear All:** Tap menu (⋮) → Clear All Tasks

## 🏗️ Project Structure

```
lib/
├── main.dart                      # App entry point
├── app/
│   ├── controllers/
│   │   └── todo_home_controller.dart  # Business logic & state
│   ├── models/
│   │   └── task.dart                  # Task data model
│   └── services/
│       ├── supabase_service.dart      # Supabase API calls
│       └── storage_service.dart       # Local storage (legacy)
└── resources/
    └── pages/
        ├── todo_home_page.dart        # Main list view
        ├── add_task_page.dart         # Add task form
        └── detail_task_page.dart      # Task details
```

## 🛠️ Technologies Used

- **Flutter** - UI framework
- **Nylo Framework** - State management & routing
- **Supabase** - Backend-as-a-Service (PostgreSQL)
- **SharedPreferences** - Local caching (optional)
- **Intl** - Date/time formatting

## 🧪 Testing

### Manual Testing Checklist

- [ ] Add new task → appears in list
- [ ] Edit task status → updates immediately
- [ ] Delete task → removes from list
- [ ] Close and reopen app → data persists
- [ ] Add task on device A → refresh on device B → task appears
- [ ] Turn off wifi → error message appears
- [ ] Turn on wifi → retry → app works again

### Multi-Device Sync Test

1. Install app on 2 devices
2. Add task on device 1
3. Pull-to-refresh on device 2
4. Task should appear on device 2 ✨

## 🐛 Troubleshooting

**Connection Error:**
- Check internet connection
- Verify `.env` file has correct credentials
- Ensure Supabase project is active

**Tasks Not Syncing:**
- Pull down to refresh manually
- Check both devices use same Supabase project
- Verify RLS is disabled in Supabase

**Build Errors:**
- Run `flutter clean && flutter pub get`
- Ensure Flutter SDK is up to date
- Check `.env` file exists and is in `.gitignore`

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Nylo Framework](https://nylo.dev/docs/6.x)
- [Supabase Docs](https://supabase.com/docs)

## 🎯 Future Enhancements

- [ ] User authentication
- [ ] Row Level Security (RLS)
- [ ] Real-time sync (Supabase Realtime)
- [ ] Offline-first with local caching
- [ ] Search and filter
- [ ] Categories/tags
- [ ] Due dates & reminders
- [ ] Priority levels
- [ ] Task sharing

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

Created as part of Flutter + Nylo + Supabase Workshop

---

**Made with ❤️ and Flutter**
EOF

echo "${GREEN}✓ Production README.md created${NC}"
echo ""

# 8. Test Flutter setup
test_flutter_setup

# 9. Commit and push
commit_and_push_branch "$BRANCH_NAME" "$COMMIT_MESSAGE"

# 10. Return to main
return_to_main

echo ""
echo "${GREEN}========================================${NC}"
echo "${GREEN}  ✓ Branch $BRANCH_NAME created!${NC}"
echo "${GREEN}========================================${NC}"
echo ""
echo "${YELLOW}What changed in this branch:${NC}"
echo "  1. ✅ intl package for beautiful date/time formatting"
echo "  2. ✅ Animated task cards with slide-in effect"
echo "  3. ✅ Gradient stats card with icons"
echo "  4. ✅ FloatingActionButton.extended with label"
echo "  5. ✅ Improved task detail page with formatted dates"
echo "  6. ✅ Better confirmation dialogs with icons"
echo "  7. ✅ About dialog in menu"
echo "  8. ✅ Production-ready README.md"
echo "  9. 🎉 App fully polished and ready for demo!"
echo ""
echo "${GREEN}========================================${NC}"
echo "${GREEN}  🎉 ALL BRANCHES COMPLETED! 🎉${NC}"
echo "${GREEN}========================================${NC}"
echo ""
echo "${CYAN}📊 Branch Summary:${NC}"
echo "  code-01-init          → Base Nylo installation"
echo "  code-02-hello-world   → Custom HomePage"
echo "  code-03-static-ui     → Static task list"
echo "  code-04-add-page      → Add task form"
echo "  code-05-detail-page   → Task detail view"
echo "  code-06-controller    → State management setup"
echo "  code-07-local-crud    → In-memory CRUD"
echo "  code-08-task-model    → Task model class"
echo "  code-09-shared-prefs  → SharedPreferences"
echo "  code-10-persistent    → Persistent CRUD"
echo "  code-11-supabase      → Supabase setup"
echo "  code-12-supabase-crud → Cloud CRUD"
echo "  code-13-cloud-sync    → Cloud sync ready"
echo "  code-14-polish        → Final polish ✨"
echo ""
echo "${YELLOW}Next steps:${NC}"
echo "  1. Run setup-git-repo.sh to initialize main branch"
echo "  2. Run individual branch scripts or run-all.sh"
echo "  3. Test each branch: git checkout code-XX → flutter run"
echo "  4. Demo workshop dari branch ke branch!"
echo ""
echo "${CYAN}Happy coding! 🚀${NC}"
echo ""

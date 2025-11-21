#!/bin/zsh
#############################################################################
# Branch: code-08-task-model
# Sesi 4 - Bagian 1: Create Task Model
#
# Tujuan:
# - Generate Task model class dengan Metro CLI
# - Implement data serialization (toJson, fromJson)
# - Convert controller dari Map<String, dynamic> ke Task model
# - Update pages untuk pakai Task model
#
# Prerequisites:
# - Branch code-07-local-crud sudah dibuat
# - Shared functions dari 00-setup-base.sh tersedia
#############################################################################

# Source shared functions
SCRIPT_DIR="${0:a:h}"
source "$SCRIPT_DIR/00-setup-base.sh"

# Configuration
BRANCH_NAME="code-08-task-model"
PREV_BRANCH="code-07-local-crud"
COMMIT_MESSAGE="Sesi 4 Part 1: Create Task model class with serialization"

echo "${BLUE}========================================${NC}"
echo "${BLUE}  Creating Branch: $BRANCH_NAME${NC}"
echo "${BLUE}========================================${NC}"
echo ""

# 1. Check prerequisites
check_prerequisites

# 2. Create branch from previous
echo "${CYAN}📌 Creating $BRANCH_NAME from $PREV_BRANCH...${NC}"
echo ""

cd "$REPO_DIR"
echo "  → Checking out $PREV_BRANCH as base..."
git checkout "$PREV_BRANCH" 2>/dev/null

echo "  → Creating new branch $BRANCH_NAME..."
git checkout -b "$BRANCH_NAME" 2>/dev/null

echo "${GREEN}✓ Branch $BRANCH_NAME created from $PREV_BRANCH${NC}"
echo ""

# 4. Create Task Model
echo "${CYAN}📝 Creating Task model class...${NC}"

# Create models directory if not exists
mkdir -p "lib/app/models"

cat > "lib/app/models/task.dart" << 'EOF'
class Task {
  // Properties
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;

  // Constructor
  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
  });

  // Convert dari JSON (Map) ke Task object
  // Dipakai saat load data dari storage
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Convert dari Task object ke JSON (Map)
  // Dipakai saat save data ke storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper method untuk copy dengan perubahan
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Override toString untuk debugging
  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted)';
  }
}
EOF

echo "${GREEN}✓ Task model created${NC}"
echo ""

# 5. Update TodoHomeController to use Task model
echo "${CYAN}📝 Updating TodoHomeController to use Task model...${NC}"

cat > "lib/app/controllers/todo_home_controller.dart" << 'EOF'
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
EOF

echo "${GREEN}✓ TodoHomeController updated with Task model${NC}"
echo ""

# 6. Update HomePage to use Task model
echo "${CYAN}📝 Updating HomePage to use Task model...${NC}"

cat > "lib/resources/pages/todo_home_page.dart" << 'EOF'
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
        title: Text('Simple ToDo App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildStatsCard(controller),
          Expanded(child: _buildTaskList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          routeTo('/add-task');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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

    // Sekarang List<Task>, bukan List<Map> lagi!
    List<Task> tasks = controller.tasks;

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey.shade300),
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
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Task task) {  // Ubah dari Map ke Task
    bool isCompleted = task.isCompleted;  // Akses property langsung

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
          task.title,  // Akses property langsung, bukan task['title']
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task.description,  // Akses property langsung
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          routeTo(
            '/detail-task',
            data: task.toJson(),  // Convert ke Map untuk passing data
          );
        },
      ),
    );
  }
}
EOF

echo "${GREEN}✓ HomePage updated with Task model${NC}"
echo ""

# 7. Update DetailTaskPage to use Task model
echo "${CYAN}📝 Updating DetailTaskPage to use Task model...${NC}"

cat > "lib/resources/pages/detail_task_page.dart" << 'EOF'
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
EOF

echo "${GREEN}✓ DetailTaskPage updated with Task model${NC}"
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
echo "  1. ✅ Task model class with serialization (toJson/fromJson)"
echo "  2. ✅ TodoHomeController uses List<Task> (not Map anymore)"
echo "  3. ✅ HomePage reads Task properties directly (task.title)"
echo "  4. ✅ DetailTaskPage converts Map to Task object"
echo "  5. ✅ copyWith() helper for immutable updates"
echo "  6. ✅ toString() override for debugging"
echo ""
echo "${CYAN}Next step: Branch code-09-shared-preferences (add data persistence)${NC}"
echo ""

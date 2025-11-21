#!/bin/zsh
#############################################################################
# Branch: code-12-supabase-crud
# Sesi 5 - Bagian 2: Replace SharedPreferences dengan Supabase
#
# Tujuan:
# - Update TodoHomeController untuk pakai SupabaseService
# - Replace StorageService dengan SupabaseService
# - Update all CRUD operations ke Supabase
# - Add error handling & loading states
# - Add pull-to-refresh functionality
#
# Prerequisites:
# - Branch code-11-supabase-setup sudah dibuat
# - Shared functions dari 00-setup-base.sh tersedia
# - User sudah configure .env file
#############################################################################

# Source shared functions
SCRIPT_DIR="${0:a:h}"
source "$SCRIPT_DIR/00-setup-base.sh"

# Configuration
BRANCH_NAME="code-12-supabase-crud"
PREV_BRANCH="code-11-supabase-setup"
COMMIT_MESSAGE="Sesi 5 Part 2: Replace SharedPreferences with Supabase CRUD"

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

# 4. Update TodoHomeController to use SupabaseService
echo "${CYAN}📝 Updating TodoHomeController to use Supabase...${NC}"

cat > "lib/app/controllers/todo_home_controller.dart" << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/task.dart';
import '/app/services/supabase_service.dart';

class TodoHomeController extends Controller {
  // State
  List<Task> tasks = [];
  bool isLoading = false;
  String? errorMessage;

  // Supabase service (ganti dari StorageService)
  final SupabaseService supabase = SupabaseService();

  @override
  construct(BuildContext context) {
    super.construct(context);

    // Load tasks from Supabase
    loadTasksFromSupabase();
  }

  /// Load tasks from Supabase
  Future<void> loadTasksFromSupabase() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch dari Supabase
      List<Task> loadedTasks = await supabase.getTasks();

      tasks = loadedTasks;

      setState(() {
        isLoading = false;
      });

      print('✅ Loaded ${tasks.length} tasks from Supabase');
    } catch (e) {
      print('❌ Error loading tasks: $e');

      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load tasks: ${e.toString()}';
      });
    }
  }

  /// Refresh tasks (pull-to-refresh)
  Future<void> refresh() async {
    await loadTasksFromSupabase();
  }

  // Helper getters
  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((t) => t.isCompleted).length;

  int get pendingTasks => tasks.where((t) => !t.isCompleted).length;

  /// Add new task to Supabase
  Future<void> addTask({
    required String title,
    String description = '',
  }) async {
    try {
      // Create task object
      Task newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      // Insert ke Supabase
      Task createdTask = await supabase.createTask(newTask);

      // Add to local list
      tasks.insert(0, createdTask);

      setState(() {});

      print('✅ Task added to Supabase: $createdTask');
    } catch (e) {
      print('❌ Error adding task: $e');
      rethrow;
    }
  }

  /// Update task in Supabase
  Future<void> updateTask({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    try {
      final taskIndex = tasks.indexWhere((t) => t.id == id);

      if (taskIndex == -1) {
        throw Exception('Task not found');
      }

      // Create updated task
      Task updatedTask = tasks[taskIndex].copyWith(
        title: title,
        description: description,
        isCompleted: isCompleted,
      );

      // Update di Supabase
      Task savedTask = await supabase.updateTask(updatedTask);

      // Update local list
      tasks[taskIndex] = savedTask;

      setState(() {});

      print('✅ Task updated in Supabase: $savedTask');
    } catch (e) {
      print('❌ Error updating task: $e');
      rethrow;
    }
  }

  /// Toggle complete status
  Future<void> toggleComplete(String id) async {
    final taskIndex = tasks.indexWhere((t) => t.id == id);

    if (taskIndex != -1) {
      await updateTask(
        id: id,
        isCompleted: !tasks[taskIndex].isCompleted,
      );
    }
  }

  /// Delete task from Supabase
  Future<void> deleteTask(String id) async {
    try {
      // Delete dari Supabase
      await supabase.deleteTask(id);

      // Remove from local list
      tasks.removeWhere((t) => t.id == id);

      setState(() {});

      print('✅ Task deleted from Supabase: $id');
    } catch (e) {
      print('❌ Error deleting task: $e');
      rethrow;
    }
  }

  /// Clear all tasks
  Future<void> clearAllTasks() async {
    try {
      await supabase.deleteAllTasks();

      tasks.clear();

      setState(() {});

      print('✅ All tasks cleared from Supabase');
    } catch (e) {
      print('❌ Error clearing tasks: $e');
      rethrow;
    }
  }

  // Filter methods
  List<Task> getTasksByStatus(bool isCompleted) {
    return tasks.where((t) => t.isCompleted == isCompleted).toList();
  }

  List<Task> get pendingTasksList => getTasksByStatus(false);
  List<Task> get completedTasksList => getTasksByStatus(true);
}
EOF

echo "${GREEN}✓ TodoHomeController updated to use Supabase${NC}"
echo ""

# 5. Update HomePage with pull-to-refresh and error handling
echo "${CYAN}📝 Updating HomePage with pull-to-refresh...${NC}"

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
        actions: [
          // Refresh button
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.refresh();
            },
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
          ],
        ),
      );
    }

    // Show error message
    if (controller.errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Failed to load tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                controller.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  controller.refresh();
                },
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
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
            Icon(Icons.cloud_done, size: 80, color: Colors.grey.shade300),
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
        subtitle: Text(
          task.description,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
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
        content: Text('This will delete all tasks from cloud permanently. Are you sure?'),
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
                  description: "Failed to clear tasks",
                  icon: Icons.error,
                  style: ToastNotificationStyleType.DANGER,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
EOF

echo "${GREEN}✓ HomePage updated with pull-to-refresh and error handling${NC}"
echo ""

# 6. Commit and push (initial commit)
commit_and_push_branch "$BRANCH_NAME" "$COMMIT_MESSAGE"

# 7. Commit pubspec.lock changes (if any)
echo "${CYAN}📝 Checking for pubspec.lock changes...${NC}"
if [[ -n $(git status --porcelain) ]]; then
    git add pubspec.lock
    git commit -m "Update pubspec.lock"
    git push origin "$BRANCH_NAME"
    echo "${GREEN}✓ pubspec.lock changes committed${NC}"
else
    echo "${GREEN}✓ No additional changes to commit${NC}"
fi
echo ""

# 8. Return to main
return_to_main

echo ""
echo "${GREEN}========================================${NC}"
echo "${GREEN}  ✓ Branch $BRANCH_NAME created!${NC}"
echo "${GREEN}========================================${NC}"
echo ""
echo "${YELLOW}What changed in this branch:${NC}"
echo "  1. ✅ TodoHomeController now uses SupabaseService (not StorageService)"
echo "  2. ✅ All CRUD operations save to Supabase cloud database"
echo "  3. ✅ Pull-to-refresh functionality added"
echo "  4. ✅ Error handling with retry button"
echo "  5. ✅ Loading states (CircularProgressIndicator)"
echo "  6. ✅ Empty state and error state UI"
echo "  7. 🎉 Data now syncs across devices via cloud!"
echo ""
echo "${CYAN}Test checklist:${NC}"
echo "  1. ✓ Add task → Check Supabase Table Editor → Task ada"
echo "  2. ✓ Toggle complete → Refresh app → Status tetap"
echo "  3. ✓ Delete task → Task hilang dari Supabase"
echo "  4. ✓ Pull down to refresh → Tasks reload from cloud"
echo "  5. ✓ Test on 2 devices → Changes sync!"
echo ""
echo "${CYAN}Next step: Branch code-13-cloud-sync (polish & final touches)${NC}"
echo ""

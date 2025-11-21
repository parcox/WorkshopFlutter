#!/bin/zsh

# ============================================
# Workshop Flutter - Create Branch code-04-add-page
# ============================================
# Branch: code-04-add-page
# Deskripsi: AddTaskPage dengan form input
# Sesi: 2 (UI & Navigation) - Bagian 2

# Load base functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/00-setup-base.sh"

# ============================================
# Main Script
# ============================================

print_header "Create Branch: code-04-add-page"

# Step 1: Check prerequisites
if ! check_prerequisites; then
    exit 1
fi

# Step 2: Clone Nylo (if not already done)
if [[ ! -d "$TEMP_DIR" ]]; then
    if ! clone_nylo_to_temp; then
        exit 1
    fi

    if ! test_flutter_setup; then
        cleanup_temp
        exit 1
    fi
else
    print_step "SKIP" "Nylo already cloned to temp (reusing)"
    echo ""
fi

# Step 3: Create branch from previous
print_step "BRANCH" "Creating code-04-add-page..."
echo ""

cd "$REPO_DIR"
print_info "Checking out code-03-static-ui as base..."
git checkout code-03-static-ui 2>/dev/null

print_info "Creating new branch code-04-add-page..."
git checkout -b code-04-add-page 2>/dev/null

# Step 4: Create AddTaskPage and Controller
print_info "Creating AddTaskPage with form..."

mkdir -p lib/resources/pages
mkdir -p lib/app/controllers

# Create AddTaskController
cat > lib/app/controllers/add_task_controller.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AddTaskController extends Controller {
  @override
  construct(BuildContext context) {
    super.construct(context);
  }
}
EOF

# Create AddTaskPage
cat > lib/resources/pages/add_task_page.dart << 'EOF'
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
EOF

# Update HomePage to add navigation
cat > lib/resources/pages/home_page.dart << 'EOF'
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
EOF

# Update routes
mkdir -p lib/routes
cat > lib/routes/router.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/resources/pages/home_page.dart';
import '/resources/pages/add_task_page.dart';

appRouter() => nyRoutes((router) {
  router.route(HomePage.path, (context) => const HomePage());
  router.route(AddTaskPage.path, (context) => const AddTaskPage());

  // Initial route
  router.route("/", (context) => const HomePage(), initialRoute: true);
});
EOF

print_success "AddTaskPage created with form and navigation"

# Step 5: Commit and push
echo ""
commit_message="code: Sesi 2 part 2 - AddTaskPage with form

- AddTaskPage dengan TextField untuk title & description
- Form validation (title tidak boleh kosong)
- Toast notifications untuk feedback
- Navigation dari HomePage FAB ke AddTaskPage
- Routes setup untuk /add-task
- Ready untuk DetailTaskPage"

if ! commit_and_push_branch "code-04-add-page" "$commit_message"; then
    echo ""
    print_error "Failed to push branch"
    echo "  You can push manually later:"
    echo "  git push origin code-04-add-page"
fi

# Step 6: Return to main
echo ""
return_to_main

# Summary
echo ""
print_header "✓ Branch code-04-add-page Created!"
echo ""
echo "Branch: ${GREEN}code-04-add-page${NC}"
echo "Status: Sesi 2 part 2 - AddTaskPage completed"
echo ""
echo "${BLUE}Test locally:${NC}"
echo "  git checkout code-04-add-page"
echo "  flutter run"
echo ""
echo "${CYAN}Features implemented:${NC}"
echo "  ✓ AddTaskPage with form (title + description)"
echo "  ✓ TextField with validation"
echo "  ✓ Toast notifications (success/error)"
echo "  ✓ Navigation from HomePage FAB"
echo "  ✓ Auto-close after save"
echo ""
echo "${YELLOW}Next:${NC}"
echo "  Branch 05: Create DetailTaskPage"
echo ""

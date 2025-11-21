#!/bin/zsh

# ============================================
# Workshop Flutter - Create Branch code-05-detail-page
# ============================================
# Branch: code-05-detail-page
# Deskripsi: DetailTaskPage untuk view task details
# Sesi: 2 (UI & Navigation) - Bagian 3 (Complete)

# Load base functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/00-setup-base.sh"

# ============================================
# Main Script
# ============================================

print_header "Create Branch: code-05-detail-page"

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
print_step "BRANCH" "Creating code-05-detail-page..."
echo ""

cd "$REPO_DIR"
print_info "Checking out code-04-add-page as base..."
git checkout code-04-add-page 2>/dev/null

print_info "Creating new branch code-05-detail-page..."
git checkout -b code-05-detail-page 2>/dev/null

# Step 4: Create DetailTaskPage
print_info "Creating DetailTaskPage..."

mkdir -p lib/resources/pages
mkdir -p lib/app/controllers

# Create DetailTaskController
cat > lib/app/controllers/detail_task_controller.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class DetailTaskController extends Controller {
  @override
  construct(BuildContext context) {
    super.construct(context);
  }
}
EOF

# Create DetailTaskPage
cat > lib/resources/pages/detail_task_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class DetailTaskPage extends StatefulWidget {
  static const path = '/detail-task';

  const DetailTaskPage({super.key});

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  // Data task yang diterima dari halaman sebelumnya
  Map<String, dynamic>? task;

  @override
  void initState() {
    super.initState();
    // Ambil data task dari route arguments
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
    // Jika task null, tampilkan loading
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
            onPressed: () {
              showToastNotification(
                context,
                title: "Delete",
                description: "Delete feature akan dibuat di sesi berikutnya",
                style: ToastNotificationStyleType.warning,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
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

            // Title
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

            // Description
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
            const SizedBox(height: 20),

            // Created date
            const Text(
              'Created At',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task!['createdAt'] ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Toggle complete button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  showToastNotification(
                    context,
                    title: "Toggle Status",
                    description: "Status update akan dibuat di sesi berikutnya (dengan Controller)",
                    style: ToastNotificationStyleType.info,
                  );
                },
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
}
EOF

# Update HomePage to navigate to DetailTaskPage
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
          // Navigate ke Detail Task Page dengan passing data
          routeTo('/detail-task', data: task);
        },
      ),
    );
  }
}
EOF

# Update routes
cat > lib/routes/router.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/resources/pages/home_page.dart';
import '/resources/pages/add_task_page.dart';
import '/resources/pages/detail_task_page.dart';

appRouter() => nyRoutes((router) {
  router.route(HomePage.path, (context) => const HomePage());
  router.route(AddTaskPage.path, (context) => const AddTaskPage());
  router.route(DetailTaskPage.path, (context) => const DetailTaskPage());

  // Initial route
  router.route("/", (context) => const HomePage(), initialRoute: true);
});
EOF

print_success "DetailTaskPage created with navigation"

# Step 5: Commit and push
echo ""
commit_message="code: Sesi 2 completed - DetailTaskPage with navigation

- DetailTaskPage untuk view task details
- Passing data via route arguments
- Display task info (title, description, status, date)
- Status badge (Completed/Pending)
- Action buttons (Edit/Delete) dengan placeholder
- Toggle status button dengan placeholder
- Full navigation: Home -> Add & Home -> Detail
- Sesi 2 (UI & Navigation) completed!"

if ! commit_and_push_branch "code-05-detail-page" "$commit_message"; then
    echo ""
    print_error "Failed to push branch"
    echo "  You can push manually later:"
    echo "  git push origin code-05-detail-page"
fi

# Step 6: Return to main
echo ""
return_to_main

# Summary
echo ""
print_header "✓ Branch code-05-detail-page Created!"
echo ""
echo "Branch: ${GREEN}code-05-detail-page${NC}"
echo "Status: Sesi 2 completed - 3 pages with navigation!"
echo ""
echo "${BLUE}Test locally:${NC}"
echo "  git checkout code-05-detail-page"
echo "  flutter run"
echo ""
echo "${CYAN}Full navigation flow:${NC}"
echo "  ✓ HomePage (list tasks)"
echo "  ✓ FAB -> AddTaskPage (form)"
echo "  ✓ Task card -> DetailTaskPage (view details)"
echo "  ✓ Data passing between pages"
echo ""
echo "${GREEN}Sesi 2 Completed!${NC}"
echo "  ✓ 3 pages built"
echo "  ✓ Navigation working"
echo "  ✓ Data passing working"
echo "  ✓ Static data (hardcoded)"
echo ""
echo "${YELLOW}Next:${NC}"
echo "  Sesi 3: State Management dengan Controllers"
echo "  Branch 06-07: TodoController & in-memory CRUD"
echo ""

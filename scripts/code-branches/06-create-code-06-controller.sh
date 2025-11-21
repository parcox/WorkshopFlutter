#!/bin/zsh

# ============================================
# Workshop Flutter - Create Branch code-06-controller
# ============================================
# Branch: code-06-controller
# Deskripsi: Setup TodoController dengan Nylo state management
# Sesi: 3 (State Management) - Bagian 1

# Load base functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/00-setup-base.sh"

# ============================================
# Main Script
# ============================================

print_header "Create Branch: code-06-controller"

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
print_step "BRANCH" "Creating code-06-controller..."
echo ""

cd "$REPO_DIR"
print_info "Checking out code-05-detail-page as base..."
git checkout code-05-detail-page 2>/dev/null

print_info "Creating new branch code-06-controller..."
git checkout -b code-06-controller 2>/dev/null

# Step 4: Create TodoHomeController
print_info "Creating TodoHomeController..."

mkdir -p lib/app/controllers

cat > lib/app/controllers/todo_home_controller.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class TodoHomeController extends Controller {
  // List untuk menyimpan tasks (in-memory)
  List<Map<String, dynamic>> tasks = [];

  @override
  construct(BuildContext context) {
    super.construct(context);

    // Initialize with sample data
    tasks = [
      {
        'id': '1',
        'title': 'Belajar Flutter',
        'description': 'Ikuti workshop Flutter dengan Nylo framework',
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': '2',
        'title': 'Setup Supabase',
        'description': 'Create project dan database di Supabase',
        'isCompleted': true,
        'createdAt': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
      },
      {
        'id': '3',
        'title': 'Build ToDo App',
        'description': 'Implementasi CRUD operations',
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];
  }

  // Helper getters untuk stats
  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((t) => t['isCompleted'] == true).length;

  int get pendingTasks => tasks.where((t) => t['isCompleted'] == false).length;

  // CRUD methods akan ditambahkan di branch berikutnya
}
EOF

# Update HomePage to use Controller
cat > lib/resources/pages/home_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/todo_home_controller.dart';

class HomePage extends NyStatefulWidget<TodoHomeController> {
  static const path = '/home';

  HomePage({super.key}) : super(child: () => _HomePageState());
}

class _HomePageState extends NyState<HomePage> {
  @override
  init() async {
    super.init();
    // Controller sudah di-initialize otomatis oleh Nylo
  }

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
    // Ambil controller
    final controller = widget.controller;

    // Ambil stats dari controller
    int totalTasks = controller.totalTasks;
    int completedTasks = controller.completedTasks;
    int pendingTasks = controller.pendingTasks;

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
    // Ambil controller
    final controller = widget.controller;

    // Ambil tasks dari controller (tidak hardcode lagi!)
    List<Map<String, dynamic>> tasks = controller.tasks;

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

print_success "TodoHomeController created and connected to HomePage"

# Step 5: Commit and push
echo ""
commit_message="code: Sesi 3 part 1 - TodoHomeController setup

- TodoHomeController dengan in-memory tasks list
- Sample data (3 tasks) initialized in construct()
- Helper getters: totalTasks, completedTasks, pendingTasks
- HomePage now uses NyStatefulWidget with controller
- Data dari controller (tidak hardcode di widget lagi)
- Stats card mengambil data dari controller
- Ready untuk CRUD operations"

if ! commit_and_push_branch "code-06-controller" "$commit_message"; then
    echo ""
    print_error "Failed to push branch"
    echo "  You can push manually later:"
    echo "  git push origin code-06-controller"
fi

# Step 6: Return to main
echo ""
return_to_main

# Summary
echo ""
print_header "✓ Branch code-06-controller Created!"
echo ""
echo "Branch: ${GREEN}code-06-controller${NC}"
echo "Status: Sesi 3 part 1 - Controller setup completed"
echo ""
echo "${BLUE}Test locally:${NC}"
echo "  git checkout code-06-controller"
echo "  flutter run"
echo ""
echo "${CYAN}Features implemented:${NC}"
echo "  ✓ TodoHomeController with in-memory list"
echo "  ✓ Sample data (3 tasks) initialized"
echo "  ✓ Getters for stats (total, completed, pending)"
echo "  ✓ HomePage uses NyStatefulWidget + Controller"
echo "  ✓ Data source dari controller (centralized)"
echo ""
echo "${YELLOW}Next:${NC}"
echo "  Branch 07: Implement CRUD operations (add, delete, toggle)"
echo ""

#!/bin/zsh

# ============================================
# Workshop Flutter - Create Branch code-03-static-ui
# ============================================
# Branch: code-03-static-ui
# Deskripsi: HomePage dengan static task list (hardcoded data)
# Sesi: 2 (UI & Navigation) - Bagian 1

# Load base functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/00-setup-base.sh"

# ============================================
# Main Script
# ============================================

print_header "Create Branch: code-03-static-ui"

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
print_step "BRANCH" "Creating code-03-static-ui..."
echo ""

# Checkout previous branch first
cd "$REPO_DIR"
print_info "Checking out code-02-hello-world as base..."
git checkout code-02-hello-world 2>/dev/null

# Create new branch from current
print_info "Creating new branch code-03-static-ui..."
git checkout -b code-03-static-ui 2>/dev/null

# Step 4: Modify HomePage with static task list
print_info "Building HomePage with static task list..."

mkdir -p lib/resources/pages

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
          showToastNotification(
            context,
            title: "Coming Soon",
            description: "Add Task feature akan dibuat di sesi berikutnya",
            style: ToastNotificationStyleType.info,
          );
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
        // Icon di kiri
        leading: CircleAvatar(
          backgroundColor: isCompleted ? Colors.green : Colors.orange,
          child: Icon(
            isCompleted ? Icons.check : Icons.circle_outlined,
            color: Colors.white,
          ),
        ),

        // Title & description
        title: Text(
          task['title'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            // Coret text jika sudah selesai
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task['description'],
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),

        // Icon di kanan
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        // Action ketika card diklik
        onTap: () {
          showToastNotification(
            context,
            title: "Task: ${task['title']}",
            description: "Detail page akan dibuat di sesi berikutnya",
            style: ToastNotificationStyleType.info,
          );
        },
      ),
    );
  }
}
EOF

print_success "HomePage.dart updated with static task list"

# Step 5: Commit and push
echo ""
commit_message="code: Sesi 2 part 1 - Static UI with task list

- HomePage dengan static task list (3 hardcoded tasks)
- Stats card: Total, Done, Pending
- Task cards dengan ListTile
- Empty state handling
- FAB untuk add task (placeholder)
- Ready untuk navigation implementation"

if ! commit_and_push_branch "code-03-static-ui" "$commit_message"; then
    echo ""
    print_error "Failed to push branch"
    echo "  You can push manually later:"
    echo "  git push origin code-03-static-ui"
fi

# Step 6: Return to main
echo ""
return_to_main

# Summary
echo ""
print_header "✓ Branch code-03-static-ui Created!"
echo ""
echo "Branch: ${GREEN}code-03-static-ui${NC}"
echo "Status: Sesi 2 part 1 - Static UI completed"
echo ""
echo "${BLUE}Test locally:${NC}"
echo "  git checkout code-03-static-ui"
echo "  flutter run"
echo ""
echo "${CYAN}Features implemented:${NC}"
echo "  ✓ Stats card (Total: 3, Done: 1, Pending: 2)"
echo "  ✓ Task list dengan 3 hardcoded tasks"
echo "  ✓ Card styling dengan ListTile"
echo "  ✓ Completed task indicator (icon hijau, text coret)"
echo "  ✓ Empty state handling"
echo "  ✓ FAB dengan toast notification"
echo ""
echo "${YELLOW}Next:${NC}"
echo "  Branch 04-05: Add navigation & create AddTaskPage/DetailTaskPage"
echo ""

#!/bin/zsh
#############################################################################
# Branch: code-13-cloud-sync
# Sesi 5 - Bagian 3: Testing, Polish & Cloud Sync Demo
#
# Tujuan:
# - Add connection status indicator
# - Improve error messages
# - Add network error handling
# - Test multi-device sync
# - Final polish for demo
#
# Prerequisites:
# - Branch code-12-supabase-crud sudah dibuat
# - Shared functions dari 00-setup-base.sh tersedia
#############################################################################

# Source shared functions
SCRIPT_DIR="${0:a:h}"
source "$SCRIPT_DIR/00-setup-base.sh"

# Configuration
BRANCH_NAME="code-13-cloud-sync"
PREV_BRANCH="code-12-supabase-crud"
COMMIT_MESSAGE="Sesi 5 Part 3: Cloud sync ready with improved error handling"

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

# 4. Update HomePage with connection status
echo "${CYAN}📝 Adding connection status to HomePage...${NC}"

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
EOF

echo "${GREEN}✓ HomePage updated with connection status${NC}"
echo ""

# 5. Create a simple README for the branch
echo "${CYAN}📝 Creating README for cloud sync demo...${NC}"

cat > "README_CLOUD_SYNC.md" << 'EOF'
# 🎉 Simple ToDo App - Cloud Sync Ready!

Aplikasi ToDo List dengan cloud synchronization menggunakan Supabase.

## ✨ Features

- ✅ **Full CRUD Operations** - Create, Read, Update, Delete tasks
- ✅ **Cloud Storage** - Data tersimpan di Supabase PostgreSQL
- ✅ **Multi-Device Sync** - Tasks sync antar devices
- ✅ **Pull-to-Refresh** - Swipe down untuk refresh data
- ✅ **Error Handling** - Graceful error messages dengan retry
- ✅ **Loading States** - Visual feedback saat loading
- ✅ **Connection Status** - Indicator koneksi ke cloud

## 🧪 Testing Cloud Sync

### Test 1: Basic CRUD Operations
1. Add new task → Check Supabase Table Editor → Task muncul
2. Toggle task complete → Refresh app → Status tetap
3. Delete task → Task hilang dari Supabase
4. Clear all → Semua tasks hilang

### Test 2: Multi-Device Sync
1. Install app di 2 devices (atau 1 device + Supabase Table Editor)
2. Add task di device 1
3. Pull-to-refresh di device 2
4. Task dari device 1 muncul di device 2! 🎉

### Test 3: Offline Handling
1. Turn off wifi/data
2. Try to add task → Error message muncul
3. Turn on wifi/data
4. Tap retry → App connects kembali

## 🔧 Configuration Check

Jika error saat connect:

1. **Check .env file:**
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   ```

2. **Verify Supabase table:**
   - Table name: `tasks`
   - Columns: `id`, `title`, `description`, `is_completed`, `created_at`, `updated_at`
   - RLS: Disabled (for workshop)

3. **Test connection:**
   - Open SUPABASE_URL di browser
   - Should response (tidak 404)

## 📱 Usage

1. **Add Task:** Tap + button → Fill form → Save
2. **View Details:** Tap task card → See details
3. **Toggle Complete:** Tap status badge di detail page
4. **Delete Task:** Tap delete icon di detail page
5. **Refresh:** Pull down atau tap refresh button
6. **Clear All:** Tap menu (⋮) → Clear All Tasks

## 🎯 What's Next?

After this workshop, you can:

- [ ] Add user authentication (Supabase Auth)
- [ ] Enable Row Level Security (RLS)
- [ ] Add real-time sync (Supabase Realtime)
- [ ] Implement offline-first with local cache
- [ ] Add search & filter features
- [ ] Support categories/tags
- [ ] Add due dates & reminders

## 🐛 Troubleshooting

**Error: "Connection refused"**
- Check internet connection
- Verify SUPABASE_URL correct

**Error: "Invalid API key"**
- Re-copy anon key from Supabase Dashboard
- Check for extra spaces in .env

**Tasks not syncing**
- Pull down to refresh
- Check both devices using same Supabase project
- Verify internet connection on both devices

## 📚 Resources

- **Supabase Dashboard:** https://app.supabase.com
- **Nylo Docs:** https://nylo.dev/docs/6.x
- **Flutter Docs:** https://docs.flutter.dev

---

**Congratulations! 🎉** You've built a full-stack Flutter app with cloud sync!
EOF

echo "${GREEN}✓ README_CLOUD_SYNC.md created${NC}"
echo ""

# 6. Test Flutter setup
test_flutter_setup

# 7. Commit and push
commit_and_push_branch "$BRANCH_NAME" "$COMMIT_MESSAGE"

# 8. Return to main
return_to_main

echo ""
echo "${GREEN}========================================${NC}"
echo "${GREEN}  ✓ Branch $BRANCH_NAME created!${NC}"
echo "${GREEN}========================================${NC}"
echo ""
echo "${YELLOW}What changed in this branch:${NC}"
echo "  1. ✅ Connection status indicator in AppBar"
echo "  2. ✅ Error banner at top when connection fails"
echo "  3. ✅ Improved error messages with troubleshooting tips"
echo "  4. ✅ Better empty state with 'connected to cloud' indicator"
echo "  5. ✅ Clear confirmation dialog warns about permanent deletion"
echo "  6. ✅ README_CLOUD_SYNC.md with testing guide"
echo "  7. 🎉 App ready for multi-device sync demo!"
echo ""
echo "${CYAN}🧪 Multi-Device Sync Test:${NC}"
echo "  1. Install app on 2 devices"
echo "  2. Add task on device 1"
echo "  3. Pull-to-refresh on device 2"
echo "  4. Task appears on device 2! ✨"
echo ""
echo "${GREEN}✓ Sesi 5 completed! (Supabase Integration)${NC}"
echo ""
echo "${CYAN}Final step: Branch code-14 (optional polish & extras)${NC}"
echo ""

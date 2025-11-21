#!/bin/zsh
#############################################################################
# Branch: code-11-supabase-setup
# Sesi 5 - Bagian 1: Supabase Setup & Integration
#
# Tujuan:
# - Install supabase_flutter package
# - Setup .env file dengan credentials
# - Initialize Supabase di main.dart
# - Create SupabaseService class
# - Update Task model dengan Supabase serialization methods
#
# Prerequisites:
# - Branch code-10-persistent-data sudah dibuat
# - Shared functions dari 00-setup-base.sh tersedia
# - User sudah create Supabase project & get API keys
#############################################################################

# Source shared functions
SCRIPT_DIR="${0:a:h}"
source "$SCRIPT_DIR/00-setup-base.sh"

# Configuration
BRANCH_NAME="code-11-supabase-setup"
PREV_BRANCH="code-10-persistent-data"
COMMIT_MESSAGE="Sesi 5 Part 1: Setup Supabase integration"

echo "${BLUE}========================================${NC}"
echo "${BLUE}  Creating Branch: $BRANCH_NAME${NC}"
echo "${BLUE}========================================${NC}"
echo ""

# 1. Check prerequisites
check_prerequisites

# 2. Clone Nylo (if not already done)
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

# 3. Create branch from previous
echo "${CYAN}📌 Creating $BRANCH_NAME from $PREV_BRANCH...${NC}"
echo ""

cd "$REPO_DIR"
echo "  → Checking out $PREV_BRANCH as base..."
git checkout "$PREV_BRANCH" 2>/dev/null

echo "  → Creating new branch $BRANCH_NAME..."
git checkout -b "$BRANCH_NAME" 2>/dev/null

echo "${GREEN}✓ Branch $BRANCH_NAME created from $PREV_BRANCH${NC}"
echo ""

# 4. Update pubspec.yaml to add supabase_flutter
echo "${CYAN}📝 Adding supabase_flutter to pubspec.yaml...${NC}"

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

echo "${GREEN}✓ pubspec.yaml updated with supabase_flutter${NC}"
echo ""

# 5. Create .env file with placeholder
echo "${CYAN}📝 Creating .env file with placeholders...${NC}"

cat > ".env" << 'EOF'
# Supabase Configuration
# Replace with your actual Supabase project credentials

SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here

# Instructions:
# 1. Go to your Supabase project dashboard
# 2. Click Settings (gear icon) → API
# 3. Copy "Project URL" and paste above (replace SUPABASE_URL)
# 4. Copy "anon/public key" and paste above (replace SUPABASE_ANON_KEY)
# 5. Save this file
#
# ⚠️ Important: Don't commit .env to git! It's already in .gitignore
EOF

echo "${GREEN}✓ .env file created (needs manual configuration)${NC}"
echo ""

# 6. Update .gitignore
echo "${CYAN}📝 Updating .gitignore to exclude .env...${NC}"

cat > ".gitignore" << 'EOF'
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# Environment variables
.env
EOF

echo "${GREEN}✓ .gitignore updated${NC}"
echo ""

# 7. Update main.dart to initialize Supabase
echo "${CYAN}📝 Updating main.dart to initialize Supabase...${NC}"

cat > "lib/main.dart" << 'EOF'
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  String envContent = await rootBundle.loadString('.env');
  Map<String, String> envVars = {};

  for (String line in envContent.split('\n')) {
    line = line.trim();
    // Skip comments and empty lines
    if (line.isEmpty || line.startsWith('#')) continue;

    // Parse KEY=VALUE
    int separatorIndex = line.indexOf('=');
    if (separatorIndex != -1) {
      String key = line.substring(0, separatorIndex).trim();
      String value = line.substring(separatorIndex + 1).trim();
      envVars[key] = value;
    }
  }

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: envVars['SUPABASE_URL'] ?? '',
      anonKey: envVars['SUPABASE_ANON_KEY'] ?? '',
    );
    print('✅ Supabase initialized successfully');
  } catch (e) {
    print('⚠️ Supabase initialization error: $e');
    print('⚠️ Please configure .env file with your Supabase credentials');
  }

  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBuild(
      navigatorKey: NyNavigator.instance.router.navigatorKey,
      onGenerateRoute: nyRoutes,
    );
  }
}
EOF

echo "${GREEN}✓ main.dart updated with Supabase initialization${NC}"
echo ""

# 8. Create SupabaseService
echo "${CYAN}📝 Creating SupabaseService...${NC}"

cat > "lib/app/services/supabase_service.dart" << 'EOF'
import 'package:supabase_flutter/supabase_flutter.dart';
import '/app/models/task.dart';

class SupabaseService {
  // Get Supabase client
  final SupabaseClient supabase = Supabase.instance.client;

  // Table name
  static const String tableName = 'tasks';

  /// Fetch all tasks from Supabase
  Future<List<Task>> getTasks() async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .order('created_at', ascending: false);

      // Convert response to List<Task>
      List<Task> tasks = (response as List)
          .map((json) => Task.fromSupabaseJson(json))
          .toList();

      print('✅ Fetched ${tasks.length} tasks from Supabase');
      return tasks;
    } catch (e) {
      print('❌ Error fetching tasks: $e');
      rethrow;
    }
  }

  /// Insert new task to Supabase
  Future<Task> createTask(Task task) async {
    try {
      final response = await supabase
          .from(tableName)
          .insert(task.toSupabaseJson())
          .select()
          .single();

      Task createdTask = Task.fromSupabaseJson(response);
      print('✅ Created task in Supabase: ${createdTask.id}');
      return createdTask;
    } catch (e) {
      print('❌ Error creating task: $e');
      rethrow;
    }
  }

  /// Update existing task in Supabase
  Future<Task> updateTask(Task task) async {
    try {
      final response = await supabase
          .from(tableName)
          .update(task.toSupabaseJson())
          .eq('id', task.id)
          .select()
          .single();

      Task updatedTask = Task.fromSupabaseJson(response);
      print('✅ Updated task in Supabase: ${updatedTask.id}');
      return updatedTask;
    } catch (e) {
      print('❌ Error updating task: $e');
      rethrow;
    }
  }

  /// Delete task from Supabase
  Future<void> deleteTask(String taskId) async {
    try {
      await supabase
          .from(tableName)
          .delete()
          .eq('id', taskId);

      print('✅ Deleted task from Supabase: $taskId');
    } catch (e) {
      print('❌ Error deleting task: $e');
      rethrow;
    }
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    try {
      // Get all task IDs first
      final tasks = await getTasks();

      // Delete one by one
      for (var task in tasks) {
        await deleteTask(task.id);
      }

      print('✅ Deleted all tasks from Supabase');
    } catch (e) {
      print('❌ Error deleting all tasks: $e');
      rethrow;
    }
  }

  /// Check connection to Supabase
  Future<bool> checkConnection() async {
    try {
      await supabase.from(tableName).select().limit(1);
      return true;
    } catch (e) {
      print('❌ Supabase connection error: $e');
      return false;
    }
  }
}
EOF

echo "${GREEN}✓ SupabaseService created${NC}"
echo ""

# 9. Update Task model with Supabase methods
echo "${CYAN}📝 Updating Task model with Supabase serialization...${NC}"

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

  // Convert dari JSON (Map) ke Task object - for SharedPreferences
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Convert dari Task object ke JSON (Map) - for SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert dari Supabase response ke Task object
  // Note: Supabase uses snake_case for column names
  factory Task.fromSupabaseJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['is_completed'] as bool? ?? false,  // snake_case dari database
      createdAt: DateTime.parse(json['created_at'] as String),  // snake_case
    );
  }

  // Convert Task object ke Supabase format (snake_case)
  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,  // Convert ke snake_case untuk database
      'created_at': createdAt.toIso8601String(),
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

echo "${GREEN}✓ Task model updated with Supabase methods${NC}"
echo ""

# 10. Test Flutter setup
test_flutter_setup

# 11. Commit and push (initial commit)
commit_and_push_branch "$BRANCH_NAME" "$COMMIT_MESSAGE"

# 12. Commit pubspec.lock changes (updated by flutter pub get)
echo "${CYAN}📝 Committing pubspec.lock changes...${NC}"
if [[ -n $(git status --porcelain) ]]; then
    git add pubspec.lock
    git commit -m "Update pubspec.lock after flutter pub get"
    git push origin "$BRANCH_NAME"
    echo "${GREEN}✓ pubspec.lock changes committed${NC}"
else
    echo "${GREEN}✓ No additional changes to commit${NC}"
fi
echo ""

# 13. Return to main
return_to_main

echo ""
echo "${GREEN}========================================${NC}"
echo "${GREEN}  ✓ Branch $BRANCH_NAME created!${NC}"
echo "${GREEN}========================================${NC}"
echo ""
echo "${YELLOW}What changed in this branch:${NC}"
echo "  1. ✅ supabase_flutter package added to pubspec.yaml"
echo "  2. ✅ .env file created (needs manual configuration)"
echo "  3. ✅ .gitignore updated to exclude .env"
echo "  4. ✅ main.dart updated to initialize Supabase"
echo "  5. ✅ SupabaseService class with CRUD methods"
echo "  6. ✅ Task model with fromSupabaseJson/toSupabaseJson"
echo ""
echo "${YELLOW}⚠️  MANUAL STEPS REQUIRED:${NC}"
echo "  1. Create Supabase project at https://supabase.com"
echo "  2. Run SQL script to create tasks table (see DATABASE_SCHEMA.md)"
echo "  3. Get API credentials from Supabase Dashboard → Settings → API"
echo "  4. Update .env file with your SUPABASE_URL and SUPABASE_ANON_KEY"
echo "  5. Hot restart app to apply changes"
echo ""
echo "${CYAN}Next step: Branch code-12-supabase-crud (replace SharedPreferences with Supabase)${NC}"
echo ""

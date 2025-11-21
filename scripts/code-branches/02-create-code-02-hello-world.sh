#!/bin/zsh

# ============================================
# Workshop Flutter - Create Branch code-02-hello-world
# ============================================
# Branch: code-02-hello-world
# Deskripsi: Modified HomePage dengan custom UI
# Sesi: 1 (Setup & Hello World) - Completion

# Load base functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/00-setup-base.sh"

# ============================================
# Main Script
# ============================================

print_header "Create Branch: code-02-hello-world"

# Step 1: Check prerequisites
if ! check_prerequisites; then
    exit 1
fi

# Step 2: Clone Nylo (if not already done by previous script)
if [[ ! -d "$TEMP_DIR" ]]; then
    if ! clone_nylo_to_temp; then
        exit 1
    fi

    # Test Flutter setup
    if ! test_flutter_setup; then
        cleanup_temp
        exit 1
    fi
else
    print_step "SKIP" "Nylo already cloned to temp (reusing)"
    echo ""
fi

# Step 3: Create branch from previous
print_step "BRANCH" "Creating code-02-hello-world from code-01-init..."
echo ""

cd "$REPO_DIR"
print_info "Checking out code-01-init as base..."
git checkout code-01-init 2>/dev/null

print_info "Creating new branch code-02-hello-world..."
git checkout -b code-02-hello-world 2>/dev/null

# Step 4: Modify HomePage
print_info "Modifying HomePage with custom UI..."

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple ToDo App"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon besar
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            // Text dengan style
            const Text(
              "Hello Flutter with Nylo!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle
            const Text(
              "Workshop Simple ToDo App",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            // Button
            ElevatedButton(
              onPressed: () {
                // Show toast notification
                showToastNotification(
                  context,
                  title: "Hello!",
                  description: "Selamat datang di Workshop Flutter",
                  style: ToastNotificationStyleType.success,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Lihat ToDo List",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

print_success "HomePage.dart modified"

# Step 5: Commit and push
echo ""
commit_message="code: Sesi 1 completed - Hello World modifications

- Modified HomePage dengan custom UI
- Added icon, styled text, dan button
- Button shows toast notification
- Ready untuk Sesi 2"

if ! commit_and_push_branch "code-02-hello-world" "$commit_message"; then
    echo ""
    print_error "Failed to push branch"
    echo "  You can push manually later:"
    echo "  git push origin code-02-hello-world"
fi

# Step 6: Return to main
echo ""
return_to_main

# Summary
echo ""
print_header "✓ Branch code-02-hello-world Created!"
echo ""
echo "Branch: ${GREEN}code-02-hello-world${NC}"
echo "Status: Sesi 1 completed dengan custom HomePage"
echo ""
echo "${BLUE}Test locally:${NC}"
echo "  git checkout code-02-hello-world"
echo "  flutter run"
echo ""
echo "${CYAN}Changes made:${NC}"
echo "  - Custom AppBar dengan title 'Simple ToDo App'"
echo "  - Icon check_circle_outline (blue, size 100)"
echo "  - Styled text 'Hello Flutter with Nylo!'"
echo "  - ElevatedButton dengan toast notification"
echo ""
echo "${YELLOW}Next branches (03-14):${NC}"
echo "  Tunggu instruksi untuk implement branches berikutnya"
echo ""

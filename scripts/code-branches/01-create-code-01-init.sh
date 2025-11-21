#!/bin/zsh

# ============================================
# Workshop Flutter - Create Branch code-01-init
# ============================================
# Branch: code-01-init
# Deskripsi: Base Nylo 6.9.1 project (fresh install)
# Sesi: 1 (Setup & Hello World)

# Load base functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/00-setup-base.sh"

# ============================================
# Main Script
# ============================================

print_header "Create Branch: code-01-init"

# Step 1: Check prerequisites
if ! check_prerequisites; then
    exit 1
fi

# Step 2: Clone Nylo (if not already done by previous script)
if [[ ! -d "$TEMP_DIR" ]]; then
    if ! clone_nylo_to_temp; then
        exit 1
    fi

    # Step 3: Test Flutter setup
    if ! test_flutter_setup; then
        cleanup_temp
        exit 1
    fi
else
    print_step "SKIP" "Nylo already cloned to temp (reusing)"
    echo ""
fi

# Step 4: Create branch
print_step "BRANCH" "Creating code-01-init..."
echo ""

create_orphan_branch "code-01-init"

# No modifications needed - this is base Nylo
print_info "Using fresh Nylo 6.9.1 (no modifications)"

# Step 5: Commit and push
echo ""
commit_message="code: Sesi 1 - Base Nylo project

- Fresh Nylo 6.9.1 installation
- Default project structure
- Ready to run with flutter run"

if ! commit_and_push_branch "code-01-init" "$commit_message"; then
    echo ""
    print_error "Failed to push branch"
    echo "  You can push manually later:"
    echo "  git push origin code-01-init"
fi

# Step 6: Return to main
echo ""
return_to_main

# Summary
echo ""
print_header "✓ Branch code-01-init Created!"
echo ""
echo "Branch: ${GREEN}code-01-init${NC}"
echo "Status: Base Nylo 6.9.1 project"
echo ""
echo "${BLUE}Test locally:${NC}"
echo "  git checkout code-01-init"
echo "  flutter run"
echo ""
echo "${CYAN}Next step:${NC}"
echo "  Run: ./scripts/code-branches/02-create-code-02-hello-world.sh"
echo ""

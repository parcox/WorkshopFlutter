#!/bin/zsh

# ============================================
# Workshop Flutter - Base Setup Functions
# ============================================
# Shared utilities untuk semua branch scripts
# Digunakan oleh: 01-create-code-01-init.sh, 02-create-code-02-hello-world.sh, dst

# Colors
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export NC='\033[0m' # No Color

# Global variables
# CRITICAL FIX: Always use git rev-parse to detect REPO_DIR
# DO NOT use ${BASH_SOURCE[0]} - it doesn't work in zsh when sourced multiple times
REPO_DIR=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$REPO_DIR" ]]; then
    REPO_DIR="$(pwd)"
fi
export REPO_DIR
export TEMP_DIR="/tmp/nylo_temp_$$"
export GITHUB_REMOTE=""

# ============================================
# Function: Print header
# ============================================
print_header() {
    local title="$1"
    echo "${BLUE}============================================${NC}"
    echo "${BLUE}${title}${NC}"
    echo "${BLUE}============================================${NC}"
    echo ""
}

# ============================================
# Function: Print step
# ============================================
print_step() {
    local step="$1"
    local description="$2"
    echo "${YELLOW}[${step}] ${description}${NC}"
}

# ============================================
# Function: Print success
# ============================================
print_success() {
    local message="$1"
    echo "${GREEN}  ✓ ${message}${NC}"
}

# ============================================
# Function: Print error
# ============================================
print_error() {
    local message="$1"
    echo "${RED}  ✗ ${message}${NC}"
}

# ============================================
# Function: Print info
# ============================================
print_info() {
    local message="$1"
    echo "${CYAN}  → ${message}${NC}"
}

# ============================================
# Function: Check prerequisites
# ============================================
check_prerequisites() {
    print_step "CHECK" "Verifying prerequisites..."

    # Check if in repo directory
    if [[ ! -d "$REPO_DIR/.git" ]]; then
        print_error "Not in a git repository"
        return 1
    fi

    # Check if GitHub remote exists
    GITHUB_REMOTE=$(git -C "$REPO_DIR" remote get-url origin 2>/dev/null || echo "")
    if [[ -z "$GITHUB_REMOTE" ]]; then
        print_error "GitHub remote tidak ditemukan"
        echo "  Jalankan dulu: ./scripts/setup-git-repo.sh"
        return 1
    fi

    # Check if on main branch
    local current_branch=$(git -C "$REPO_DIR" branch --show-current)
    if [[ "$current_branch" != "main" ]]; then
        print_error "Harus berada di branch main"
        echo "  Run: git checkout main"
        return 1
    fi

    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter not found in PATH"
        echo "  Install Flutter dari: https://docs.flutter.dev/get-started/install"
        return 1
    fi

    print_success "All prerequisites met"
    print_info "Repository: $REPO_DIR"
    print_info "GitHub remote: $GITHUB_REMOTE"
    echo ""

    return 0
}

# ============================================
# Function: Clone Nylo to temp
# ============================================
clone_nylo_to_temp() {
    print_step "CLONE" "Cloning Nylo framework to temp..."

    # Remove existing temp if any
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi

    print_info "Target: $TEMP_DIR"
    print_info "This may take a few minutes..."

    if git clone https://github.com/nylo-core/nylo.git "$TEMP_DIR" 2>/dev/null; then
        print_success "Nylo framework cloned"
    else
        print_error "Failed to clone Nylo"
        return 1
    fi

    echo ""
    return 0
}

# ============================================
# Function: Test Flutter in temp
# ============================================
test_flutter_setup() {
    print_step "TEST" "Testing Flutter setup..."

    cd "$TEMP_DIR"
    print_info "Running flutter pub get..."

    if flutter pub get > /dev/null 2>&1; then
        print_success "Dependencies installed"
    else
        print_error "flutter pub get failed"
        cd "$REPO_DIR"
        return 1
    fi

    cd "$REPO_DIR"
    echo ""
    return 0
}

# ============================================
# Function: Create orphan branch
# ============================================
create_orphan_branch() {
    local branch_name="$1"
    local commit_message="$2"

    print_info "Creating orphan branch: $branch_name"

    cd "$REPO_DIR"

    # Create orphan branch (no history)
    git checkout --orphan "$branch_name" 2>/dev/null

    # Remove all files from index (docs, etc)
    git rm -rf . > /dev/null 2>&1 || true

    # Copy Nylo files
    print_info "Copying Nylo files..."
    cp -R "$TEMP_DIR"/* "$REPO_DIR/"
    cp "$TEMP_DIR"/.gitignore "$REPO_DIR/" 2>/dev/null || true

    # Add minimal README for code branch
    cat > README.md << 'EOF'
# Simple ToDo App - Code Branch

Ini adalah code branch untuk Workshop Flutter Nylo + Supabase.

## Branch Structure
- `main`: Documentation only
- `code-XX-*`: Code implementations per sesi

## Run Project
```bash
flutter pub get
flutter run
```

## Dokumentasi
Checkout ke branch `main` untuk dokumentasi lengkap:
```bash
git checkout main
```
EOF

    return 0
}

# ============================================
# Function: Commit and push branch
# ============================================
commit_and_push_branch() {
    local branch_name="$1"
    local commit_message="$2"

    cd "$REPO_DIR"

    print_info "Committing changes..."
    git add .
    git commit -m "$commit_message"

    print_info "Pushing $branch_name..."
    if git push origin "$branch_name" 2>/dev/null; then
        print_success "$branch_name pushed to GitHub"
    else
        print_error "Push failed (might need to authenticate)"
        echo "  Retry manual: git push origin $branch_name"
        return 1
    fi

    return 0
}

# ============================================
# Function: Cleanup temp directory
# ============================================
cleanup_temp() {
    if [[ -d "$TEMP_DIR" ]]; then
        print_info "Cleaning up temp directory..."
        rm -rf "$TEMP_DIR"
        print_success "Temp directory removed"
    fi
}

# ============================================
# Function: Return to main branch
# ============================================
return_to_main() {
    cd "$REPO_DIR"
    print_info "Returning to main branch..."

    # Checkout main branch
    if ! git checkout main 2>/dev/null; then
        print_error "Failed to checkout main branch"
        return 1
    fi

    # CRITICAL: Clean untracked files left by orphan branch operations
    print_info "Cleaning untracked files..."
    git clean -fd

    print_info "Cleaning ignored files..."
    git clean -fdx

    # Verify main is clean (check for Flutter-specific files)
    local unexpected_files=$(find . -maxdepth 1 \( -name "lib" -o -name "android" -o -name "ios" -o -name ".dart_tool" -o -name "pubspec.yaml" -o -name "pubspec.lock" \) 2>/dev/null)
    if [[ -n "$unexpected_files" ]]; then
        print_error "Warning: Flutter files still present in main branch"
        echo "$unexpected_files"
    fi

    print_success "Back to main branch (verified clean)"
}

# ============================================
# Export functions for child scripts
# ============================================
export -f print_header
export -f print_step
export -f print_success
export -f print_error
export -f print_info
export -f check_prerequisites
export -f clone_nylo_to_temp
export -f test_flutter_setup
export -f create_orphan_branch
export -f commit_and_push_branch
export -f cleanup_temp
export -f return_to_main

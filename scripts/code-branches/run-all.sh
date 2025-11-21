#!/bin/zsh

# ============================================
# Workshop Flutter - Run All Branch Scripts
# ============================================
# Execute all branch creation scripts sequentially
# Usage: ./run-all.sh [start_number]
# Example: ./run-all.sh     → Run all (01-14)
# Example: ./run-all.sh 3   → Run from 03 onwards

# Load base functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/00-setup-base.sh"

# ============================================
# Configuration
# ============================================

START_FROM=${1:-1}  # Default start from branch 01

print_header "Workshop Flutter - Batch Branch Creation"

echo "${CYAN}Configuration:${NC}"
echo "  Repository: $REPO_DIR"
echo "  Starting from: Branch $(printf '%02d' $START_FROM)"
echo ""

read "confirm?Lanjutkan create branches? (y/n): "
if [[ "$confirm" != "y" ]]; then
    echo "${YELLOW}Cancelled.${NC}"
    exit 0
fi

echo ""

# ============================================
# Clone Nylo once (reused by all scripts)
# ============================================

print_header "Step 1: Clone Nylo Framework"

if ! clone_nylo_to_temp; then
    exit 1
fi

if ! test_flutter_setup; then
    cleanup_temp
    exit 1
fi

echo ""

# ============================================
# Execute branch scripts
# ============================================

print_header "Step 2: Create Branches"

# Track success/failure
declare -a CREATED_BRANCHES
declare -a FAILED_BRANCHES

# Find all numbered scripts
for script in "$SCRIPT_DIR"/[0-9][0-9]-create-*.sh; do
    if [[ ! -f "$script" ]]; then
        continue
    fi

    # Extract branch number
    script_name=$(basename "$script")
    branch_num=$(echo "$script_name" | grep -o '^[0-9]\+')

    # Skip if before start number
    if [[ $branch_num -lt $START_FROM ]]; then
        echo "${CYAN}Skipping branch $branch_num (before start point)${NC}"
        continue
    fi

    # Skip 00-setup-base.sh (not a branch script)
    if [[ $branch_num -eq 0 ]]; then
        continue
    fi

    echo ""
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "${BLUE}Executing: $script_name${NC}"
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Execute script
    if zsh "$script"; then
        CREATED_BRANCHES+=("$script_name")
        print_success "Branch $branch_num created successfully"
    else
        FAILED_BRANCHES+=("$script_name")
        print_error "Branch $branch_num failed"

        read "continue_on_error?Continue with next branch? (y/n): "
        if [[ "$continue_on_error" != "y" ]]; then
            echo ""
            print_error "Stopped by user"
            break
        fi
    fi
done

# ============================================
# Cleanup
# ============================================

echo ""
print_header "Step 3: Cleanup"

cleanup_temp
return_to_main

# ============================================
# Summary
# ============================================

echo ""
print_header "Batch Creation Summary"

echo ""
echo "${GREEN}✓ Successfully created (${#CREATED_BRANCHES[@]}):${NC}"
if [[ ${#CREATED_BRANCHES[@]} -eq 0 ]]; then
    echo "  (none)"
else
    for branch in "${CREATED_BRANCHES[@]}"; do
        echo "  - $branch"
    done
fi

echo ""
if [[ ${#FAILED_BRANCHES[@]} -gt 0 ]]; then
    echo "${RED}✗ Failed (${#FAILED_BRANCHES[@]}):${NC}"
    for branch in "${FAILED_BRANCHES[@]}"; do
        echo "  - $branch"
    done
    echo ""
fi

echo "${BLUE}Verify di GitHub:${NC}"
echo "  $GITHUB_REMOTE/branches"
echo ""

echo "${CYAN}Test locally:${NC}"
echo "  git branch -a                    # List all branches"
echo "  git checkout code-XX-name        # Switch to branch"
echo "  flutter run                      # Test app"
echo ""

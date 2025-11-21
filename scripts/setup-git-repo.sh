#!/bin/zsh

# ============================================
# Workshop Flutter - Git Repository Setup
# ============================================
# Script ini akan:
# 1. Commit docs ke main branch
# 2. Push ke GitHub (perlu input repo URL)
# 3. Prepare untuk code branches
# ============================================

set -e  # Exit on error

# Colors untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "${BLUE}============================================${NC}"
echo "${BLUE}Workshop Flutter - Git Setup Script${NC}"
echo "${BLUE}============================================${NC}"
echo ""

# Check if we're in the right directory
if [[ ! -f "README.md" ]] || [[ ! -d "docs" ]]; then
    echo "${RED}ERROR: Script harus dijalankan dari root folder WorkshopFlutter${NC}"
    echo "Current directory: $(pwd)"
    exit 1
fi

# Step 1: Initialize git if not already
echo "${YELLOW}[1/6] Checking Git initialization...${NC}"
if [[ ! -d ".git" ]]; then
    echo "  → Initializing git repository..."
    git init
    echo "${GREEN}  ✓ Git initialized${NC}"
else
    echo "${GREEN}  ✓ Git already initialized${NC}"
fi
echo ""

# Step 2: Check if there are uncommitted changes
echo "${YELLOW}[2/6] Checking for uncommitted changes...${NC}"
if [[ -n $(git status --porcelain) ]]; then
    echo "  → Found uncommitted changes"
    git status --short
    echo ""
    echo "  → Staging all files..."
    git add .
    echo "${GREEN}  ✓ Files staged${NC}"
else
    echo "${GREEN}  ✓ No uncommitted changes${NC}"
fi
echo ""

# Step 3: Commit docs to main
echo "${YELLOW}[3/6] Committing documentation to main branch...${NC}"
if [[ -n $(git status --porcelain) ]]; then
    git commit -m "docs: Complete workshop documentation

- 5 session modules (sesi-01 to sesi-05)
- Workshop outline & branch strategy guide
- Database schema for Supabase
- README files for both root & modules
- Copilot instructions for AI assistance

Target: Absolute beginners learning Flutter, Nylo, and Supabase
Duration: 8 hours (5 sessions)
App: Simple ToDo List with cloud sync"
    echo "${GREEN}  ✓ Documentation committed${NC}"
else
    echo "${GREEN}  ✓ No changes to commit${NC}"
fi
echo ""

# Step 4: Rename branch to main if needed
echo "${YELLOW}[4/6] Ensuring branch is named 'main'...${NC}"
current_branch=$(git branch --show-current)
if [[ "$current_branch" != "main" ]]; then
    echo "  → Current branch: $current_branch"
    echo "  → Renaming to 'main'..."
    git branch -M main
    echo "${GREEN}  ✓ Branch renamed to main${NC}"
else
    echo "${GREEN}  ✓ Already on main branch${NC}"
fi
echo ""

# Step 5: Get GitHub repo URL
echo "${YELLOW}[5/6] Setting up remote repository...${NC}"
if git remote | grep -q "origin"; then
    existing_remote=$(git remote get-url origin)
    echo "  → Remote 'origin' already exists: ${existing_remote}"
    echo ""
    read "confirm?Apakah Anda ingin menggunakan remote ini? (y/n): "
    if [[ "$confirm" != "y" ]]; then
        read "repo_url?Masukkan GitHub repository URL baru: "
        git remote set-url origin "$repo_url"
        echo "${GREEN}  ✓ Remote updated${NC}"
    else
        echo "${GREEN}  ✓ Using existing remote${NC}"
    fi
else
    echo "  Remote 'origin' belum diset."
    echo "  Buat dulu repository di GitHub: https://github.com/new"
    echo ""
    read "repo_url?Masukkan GitHub repository URL (format: https://github.com/username/repo.git): "

    if [[ -z "$repo_url" ]]; then
        echo "${RED}  ✗ URL tidak boleh kosong${NC}"
        exit 1
    fi

    git remote add origin "$repo_url"
    echo "${GREEN}  ✓ Remote 'origin' added${NC}"
fi
echo ""

# Step 6: Push to GitHub
echo "${YELLOW}[6/6] Pushing to GitHub...${NC}"
echo "  → Pushing main branch..."
if git push -u origin main; then
    echo "${GREEN}  ✓ Successfully pushed to GitHub!${NC}"
else
    echo "${RED}  ✗ Push failed. Possible reasons:${NC}"
    echo "    - Repository belum dibuat di GitHub"
    echo "    - Authentication error (perlu setup SSH key atau token)"
    echo "    - Network issue"
    echo ""
    echo "  Manual push command:"
    echo "    git push -u origin main"
    exit 1
fi
echo ""

# Summary
echo "${GREEN}============================================${NC}"
echo "${GREEN}✓ Git Setup Complete!${NC}"
echo "${GREEN}============================================${NC}"
echo ""
echo "Main branch (docs) berhasil di-push ke GitHub."
echo "URL Repository: $(git remote get-url origin)"
echo ""
echo "${BLUE}Next Steps:${NC}"
echo "1. Verify di GitHub - buka: $(git remote get-url origin | sed 's/\.git$//')"
echo "2. Create code branches dengan script yang tersedia:"
echo ""
echo "   ${YELLOW}Option A - Run semua branches sekaligus:${NC}"
echo "   cd scripts/code-branches"
echo "   ./run-all.sh"
echo ""
echo "   ${YELLOW}Option B - Run per branch (manual):${NC}"
echo "   cd scripts/code-branches"
echo "   ./01-create-code-01-init.sh"
echo "   ./02-create-code-02-hello-world.sh"
echo "   # ... dst sampai branch 14"
echo ""
echo "   ${YELLOW}Option C - Run per sesi:${NC}"
echo "   ./run-all.sh 1 2    # Sesi 1 only (branch 01-02)"
echo "   ./run-all.sh 3 5    # Sesi 2 only (branch 03-05)"
echo "   ./run-all.sh 6 7    # Sesi 3 only (branch 06-07)"
echo "   ./run-all.sh 8 10   # Sesi 4 only (branch 08-10)"
echo "   ./run-all.sh 11 14  # Sesi 5 + Bonus (branch 11-14)"
echo ""
echo "3. Test branch yang sudah dibuat:"
echo "   git checkout code-01-init"
echo "   flutter run"
echo ""

# 🔧 Workshop Setup Scripts

Folder ini berisi automation scripts untuk setup Git repository dan code branches.

## 📋 Scripts

### 1. `setup-git-repo.sh`
**Purpose:** Initialize Git, commit docs, dan push ke GitHub

**What it does:**
- Initialize git repository jika belum ada
- Stage & commit semua documentation files
- Rename branch ke `main` jika perlu
- Setup remote GitHub repository
- Push docs ke `main` branch

**Usage:**
```bash
cd /Users/bowo/Workspaces/Github/WorkshopFlutter
chmod +x scripts/setup-git-repo.sh
./scripts/setup-git-repo.sh
```

**Prerequisites:**
- GitHub account sudah login (via SSH key atau token)
- Repository sudah dibuat di GitHub: https://github.com/new

---

### 2. `create-code-branches.sh`
**Purpose:** Clone Nylo, create initial code branches

**What it does:**
- Clone Nylo framework ke folder `../simple_todo_app`
- Remove Nylo's git history
- Create `code-01-init` branch (base Nylo)
- Create `code-02-hello-world` branch (Sesi 1 completed)
- Push branches ke GitHub

**Usage:**
```bash
chmod +x scripts/create-code-branches.sh
./scripts/create-code-branches.sh
```

**Prerequisites:**
- `setup-git-repo.sh` sudah dijalankan
- Flutter SDK terinstall (`flutter --version`)
- Internet connection stabil

**Output:**
- Folder: `../simple_todo_app/` berisi Nylo project
- 2 branches pushed: `code-01-init`, `code-02-hello-world`

---

## 🚀 Step-by-Step Execution

### Step 1: Setup GitHub Repo (5 menit)
```bash
# 1. Buat repository baru di GitHub
#    → Go to: https://github.com/new
#    → Nama: WorkshopFlutter
#    → Visibility: Public atau Private
#    → Jangan initialize dengan README (already have)
#    → Create repository

# 2. Run setup script
cd /Users/bowo/Workspaces/Github/WorkshopFlutter
chmod +x scripts/*.sh
./scripts/setup-git-repo.sh

# 3. Input GitHub URL saat diminta
#    Format: https://github.com/YOUR_USERNAME/WorkshopFlutter.git
```

**Expected output:**
```
✓ Git Setup Complete!
Main branch (docs) berhasil di-push ke GitHub.
```

**Verify:**
- Open: https://github.com/YOUR_USERNAME/WorkshopFlutter
- Should see: README.md, docs/, .github/ folders

---

### Step 2: Create Code Branches (10 menit)
```bash
# Run code branches script
./scripts/create-code-branches.sh
```

**Expected output:**
```
✓ Initial Code Branches Created!
Branches created:
  ✓ code-01-init
  ✓ code-02-hello-world
```

**Verify:**
- GitHub → Branches → should see 3 branches total:
  - `main` (docs)
  - `code-01-init` (base Nylo)
  - `code-02-hello-world` (Sesi 1)

---

### Step 3: Test Code Branches (5 menit)
```bash
# Navigate to code directory
cd ../simple_todo_app

# Test branch 01
git checkout code-01-init
flutter pub get
flutter run
# → Should see default Nylo app

# Test branch 02
git checkout code-02-hello-world
flutter run
# → Should see "Hello Flutter with Nylo!" with icon & button
```

---

## 🐛 Troubleshooting

### Error: "GitHub authentication failed"
**Solution:**
```bash
# Setup SSH key (recommended)
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
# → Add to GitHub: Settings → SSH Keys

# OR use HTTPS with token
# Generate token: GitHub → Settings → Developer settings → Personal access tokens
```

### Error: "Flutter not found"
**Solution:**
```bash
# Check Flutter installation
flutter --version

# If not installed:
# Download from: https://docs.flutter.dev/get-started/install
```

### Error: "git clone failed"
**Solution:**
```bash
# Check internet connection
# Try manual clone:
git clone https://github.com/nylo-core/nylo.git
```

### Error: "Remote already exists"
**Solution:**
- Script will ask if you want to use existing remote
- Choose `y` to continue
- Or choose `n` to enter new URL

---

## 📝 Report Template

Setelah menjalankan scripts, report hasilnya dengan format:

```
=== HASIL EKSEKUSI ===

Script 1 (setup-git-repo.sh):
[ ] SUCCESS / [ ] FAILED
Error (jika ada): ___________
GitHub URL: https://github.com/___/___

Script 2 (create-code-branches.sh):
[ ] SUCCESS / [ ] FAILED
Error (jika ada): ___________
Branches created: ___________

Testing (flutter run):
code-01-init:
  [ ] SUCCESS / [ ] FAILED
  Screenshot/Error: ___________

code-02-hello-world:
  [ ] SUCCESS / [ ] FAILED
  Screenshot/Error: ___________

=== END REPORT ===
```

---

## 🔜 Next Steps

Setelah scripts ini berhasil:
1. Report hasil ke instruktur/developer
2. Terima script untuk branches 03-14 (akan dibuat bertahap)
3. Test semua branches sebelum workshop
4. Prepare Supabase account untuk Sesi 5

---

**Created:** November 21, 2025
**Author:** Workshop Team
**Contact:** _your-email@example.com_

# Database Schema - Simple ToDo List Workshop

## 🗄️ Overview

Simple ToDo List menggunakan **Supabase** sebagai backend dengan PostgreSQL. Database ini sangat sederhana - hanya 1 table untuk workshop pemula.

**Simplified Design:**
- ✅ **No Authentication**: Public access untuk kesederhanaan
- ✅ **Single Table**: Hanya `tasks` table
- ✅ **No RLS**: Row Level Security di-disable untuk workshop
- ✅ **Focus**: Belajar CRUD operations basics

⚠️ **Note**: Ini design untuk **learning purposes** saja. Production apps HARUS pakai authentication & RLS!

## 📊 Database Diagram

```
┌─────────────────────────────────────────┐
│              tasks                      │
├─────────────────────────────────────────┤
│ id              TEXT (PK)               │
│ title           TEXT NOT NULL           │
│ description     TEXT                    │
│ is_completed    BOOLEAN DEFAULT false   │
│ created_at      TIMESTAMP WITH TIME ZONE│
│ updated_at      TIMESTAMP WITH TIME ZONE│
└─────────────────────────────────────────┘

No foreign keys (single table design)
No user relationships (no auth)
```

## 🔧 Quick Setup Guide

### Step 1: Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Sign up dengan GitHub atau email
3. Klik **New Project**
4. Isi form:
   - **Name**: `todo-app-workshop`
   - **Database Password**: Buat password kuat (simpan!)
   - **Region**: Southeast Asia (Singapore)
   - **Pricing Plan**: Free
5. Wait ~2 minutes untuk project setup

### Step 2: Get API Credentials
1. Di Dashboard → **Settings** → **API**
2. Copy 2 values ini:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon/public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

### Step 3: Create .env File
Create file `.env` di root project:
```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

⚠️ **Jangan lupa** add `.env` ke `.gitignore`!

## 📋 Complete Schema - Copy & Paste Ready! ✨

### SQL Script untuk Supabase

**Di Supabase Dashboard:**
1. Klik **SQL Editor** di sidebar
2. Klik **New query**
3. Copy & paste script ini
4. Klik **Run** ▶️

```sql
-- ============================================
-- Simple ToDo List Database Schema
-- Workshop: Flutter Nylo + Supabase
-- ============================================

-- Create tasks table
CREATE TABLE tasks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  is_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes untuk performa query
CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);
CREATE INDEX idx_tasks_is_completed ON tasks(is_completed);

-- Add trigger untuk auto-update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_tasks_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Disable RLS untuk workshop (kesederhanaan)
ALTER TABLE tasks DISABLE ROW LEVEL SECURITY;

-- Insert sample data untuk testing
INSERT INTO tasks (id, title, description, is_completed, created_at)
VALUES
  ('sample-1', 'Welcome to Supabase!', 'This is a sample task from cloud database', false, NOW()),
  ('sample-2', 'Try adding a new task', 'Tap the + button to create your first task', false, NOW()),
  ('sample-3', 'Mark task as completed', 'Tap the checkbox to mark this task done', false, NOW());

-- Verify setup
SELECT
  'Setup successful! ' || COUNT(*) || ' sample tasks created.' as message
FROM tasks;
```

### 💡 Penjelasan Schema

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `id` | TEXT | Primary key - string ID dari Flutter (timestamp-based) |
| `title` | TEXT | Judul task - **REQUIRED** |
| `description` | TEXT | Deskripsi detail - optional, default empty string |
| `is_completed` | BOOLEAN | Status completed - default `false` |
| `created_at` | TIMESTAMP | Kapan task dibuat - **REQUIRED** |
| `updated_at` | TIMESTAMP | Auto-update setiap kali record di-update |

**Indexes:**
- `idx_tasks_created_at`: Speed up sorting by newest first
- `idx_tasks_is_completed`: Speed up filtering by status

**Triggers:**
- `update_tasks_updated_at`: Otomatis update `updated_at` setiap kali record di-edit

**Security:**
- ⚠️ **RLS Disabled**: Anyone dapat access semua data (OK untuk workshop)
- 🔒 **Production**: Harus enable RLS + Auth!

### ✅ Verify Setup

**Check table di Table Editor:**
1. Klik **Table Editor** di sidebar
2. Pilih table `tasks`
3. Harus ada 3 sample rows

**Test query manual:**
```sql
-- Get all tasks
SELECT * FROM tasks ORDER BY created_at DESC;

-- Get only completed tasks
SELECT * FROM tasks WHERE is_completed = true;

-- Count tasks by status
SELECT
  is_completed,
  COUNT(*) as count
FROM tasks
GROUP BY is_completed;
```

## 🔄 Bonus: Real-time Setup (Optional)

Jika ingin tasks otomatis sync real-time antar devices:

### Step 1: Enable Replication
1. Di Supabase Dashboard → **Database** → **Replication**
2. Find table `tasks`
3. Toggle **ON** untuk enable real-time

### Step 2: Subscribe di Flutter (Advanced)
```dart
// Subscribe to real-time changes
final subscription = supabase
  .from('tasks')
  .stream(primaryKey: ['id'])
  .order('created_at')
  .listen((data) {
    // Update UI when data changes
    setState(() {
      tasks = data.map((json) => Task.fromSupabaseJson(json)).toList();
    });
  });

// Don't forget to cancel subscription
@override
void dispose() {
  subscription.cancel();
  super.dispose();
}
```

⚠️ **Note**: Real-time bukan bagian dari workshop inti, tapi fun untuk dicoba!

## 📊 Add More Sample Data

Jika ingin tambah sample data untuk testing:

```sql
-- Add more sample tasks
INSERT INTO tasks (id, title, description, is_completed, created_at)
VALUES
  ('task-' || gen_random_uuid(), 'Belajar Flutter Basics', 'Selesaikan tutorial Flutter fundamentals', false, NOW() - INTERVAL '1 day'),
  ('task-' || gen_random_uuid(), 'Setup Supabase Project', 'Create account dan setup first project', true, NOW() - INTERVAL '2 days'),
  ('task-' || gen_random_uuid(), 'Build ToDo App', 'Complete workshop dengan CRUD operations', false, NOW() - INTERVAL '3 hours'),
  ('task-' || gen_random_uuid(), 'Deploy to Production', 'Deploy app ke Google Play Store', false, NOW() - INTERVAL '1 hour');

-- Verify
SELECT COUNT(*) as total_tasks FROM tasks;
```

## 🔍 Useful SQL Queries

### Get All Tasks (Newest First)
```sql
SELECT * FROM tasks
ORDER BY created_at DESC;
```

### Get Only Pending Tasks
```sql
SELECT * FROM tasks
WHERE is_completed = false
ORDER BY created_at DESC;
```

### Get Only Completed Tasks
```sql
SELECT * FROM tasks
WHERE is_completed = true
ORDER BY created_at DESC;
```

### Count Tasks by Status
```sql
SELECT
  CASE WHEN is_completed THEN 'Completed' ELSE 'Pending' END as status,
  COUNT(*) as count
FROM tasks
GROUP BY is_completed;
```

### Search Tasks by Title
```sql
SELECT * FROM tasks
WHERE title ILIKE '%flutter%'
ORDER BY created_at DESC;
```

### Get Tasks Created Today
```sql
SELECT * FROM tasks
WHERE DATE(created_at) = CURRENT_DATE
ORDER BY created_at DESC;
```

### Get Recently Updated Tasks
```sql
SELECT * FROM tasks
ORDER BY updated_at DESC
LIMIT 10;
```

### Delete Completed Tasks (Bulk)
```sql
DELETE FROM tasks
WHERE is_completed = true;
```

### Reset All Tasks to Pending
```sql
UPDATE tasks
SET is_completed = false;
```

## 🛡️ Security Notes

### ⚠️ Workshop Setup (Current)
- **RLS**: Disabled - anyone dapat access semua data
- **Auth**: Tidak ada - public access
- **Use Case**: Workshop/learning purposes ONLY

### 🔒 Production Requirements (Future)
Jika deploy ke production, **WAJIB** implement:

```sql
-- 1. Enable RLS
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- 2. Create policy untuk authenticated users only
CREATE POLICY "Users can manage their own tasks" ON tasks
  FOR ALL USING (auth.uid()::text = user_id);

-- 3. Add user_id column
ALTER TABLE tasks ADD COLUMN user_id UUID REFERENCES auth.users(id);
```

**Additional Security:**
- ✅ Enable Supabase Auth (email/password atau social login)
- ✅ Use HTTPS only (automatic di Supabase)
- ✅ Validate input di client & server
- ✅ Set rate limiting di Supabase Dashboard
- ✅ Monitor logs untuk suspicious activity
- ✅ Regular backup data

## 🔧 Database Management

### Reset Database (Delete All Data)
```sql
-- ⚠️ WARNING: Deletes all tasks!
DELETE FROM tasks;

-- Re-insert sample data
INSERT INTO tasks (id, title, description, is_completed, created_at)
VALUES
  ('sample-1', 'Welcome to Supabase!', 'This is a sample task from cloud database', false, NOW()),
  ('sample-2', 'Try adding a new task', 'Tap the + button to create your first task', false, NOW());
```

### Drop & Recreate Table (Nuclear Option)
```sql
-- ⚠️ WARNING: Completely removes table structure!
DROP TABLE IF EXISTS tasks;

-- Then re-run create table script dari atas
```

### Backup Data (Export)
```sql
-- Copy output untuk backup
SELECT
  'INSERT INTO tasks (id, title, description, is_completed, created_at) VALUES' ||
  string_agg(
    format('(%L, %L, %L, %s, %L)', id, title, description, is_completed, created_at),
    ', '
  ) || ';'
FROM tasks;
```

## 📈 Performance Tips

### Indexes Already Created ✅
```sql
-- These are already in the setup script:
CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);
CREATE INDEX idx_tasks_is_completed ON tasks(is_completed);
```

**Why?**
- `created_at` index: Speeds up sorting newest first
- `is_completed` index: Speeds up filtering by status

### Query Best Practices
```sql
-- Good ✅ - Specific columns
SELECT id, title, is_completed FROM tasks;

-- Avoid ❌ - Select all if only need few
SELECT * FROM tasks;

-- Good ✅ - Filter with index
SELECT * FROM tasks WHERE is_completed = false;

-- Good ✅ - Limit results
SELECT * FROM tasks ORDER BY created_at DESC LIMIT 20;
```

### App-Level Optimization
- **Pagination**: Load 20 tasks at a time, not all
- **Caching**: Store recent queries in memory
- **Debounce**: Wait 300ms before search query
- **Lazy Loading**: Load details only when needed

## 🧪 Testing Checklist

### Test di SQL Editor

**1. Verify Table Created:**
```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public' AND table_name = 'tasks';
-- Should return: tasks
```

**2. Check Sample Data:**
```sql
SELECT COUNT(*) as total FROM tasks;
-- Should return: 3 (or more)
```

**3. Test Insert:**
```sql
INSERT INTO tasks (id, title, is_completed, created_at)
VALUES ('test-1', 'Test Task', false, NOW());

SELECT * FROM tasks WHERE id = 'test-1';
-- Should return the new task
```

**4. Test Update:**
```sql
UPDATE tasks
SET is_completed = true
WHERE id = 'test-1';

SELECT is_completed FROM tasks WHERE id = 'test-1';
-- Should return: true
```

**5. Test Delete:**
```sql
DELETE FROM tasks WHERE id = 'test-1';

SELECT * FROM tasks WHERE id = 'test-1';
-- Should return: no rows
```

### Test di Flutter App

**Di Sesi 5 workshop:**
- [ ] App connect ke Supabase tanpa error
- [ ] Tasks load dari database
- [ ] Add task → muncul di Supabase Table Editor
- [ ] Update task → is_completed berubah di database
- [ ] Delete task → hilang dari database
- [ ] Multi-device: Changes sync antar devices

## 🚀 Next Steps After Workshop

### Level 1: Add More Fields
```sql
ALTER TABLE tasks ADD COLUMN priority TEXT DEFAULT 'medium';
ALTER TABLE tasks ADD COLUMN due_date TIMESTAMP WITH TIME ZONE;
ALTER TABLE tasks ADD COLUMN tags TEXT[];

-- Add constraint
ALTER TABLE tasks ADD CONSTRAINT check_priority
  CHECK (priority IN ('low', 'medium', 'high', 'urgent'));
```

### Level 2: Add Categories/Lists
```sql
CREATE TABLE task_lists (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  color TEXT DEFAULT '#3B82F6',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add foreign key to tasks
ALTER TABLE tasks ADD COLUMN list_id TEXT REFERENCES task_lists(id);
```

### Level 3: Add User Authentication
```sql
-- Enable Auth di Supabase Dashboard
-- Add user_id column
ALTER TABLE tasks ADD COLUMN user_id UUID REFERENCES auth.users(id);

-- Enable RLS
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users see own tasks" ON tasks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users manage own tasks" ON tasks
  FOR ALL USING (auth.uid() = user_id);
```

### Level 4: Add Sharing/Collaboration
```sql
CREATE TABLE task_shares (
  task_id TEXT REFERENCES tasks(id) ON DELETE CASCADE,
  shared_with UUID REFERENCES auth.users(id),
  permission TEXT DEFAULT 'view' CHECK (permission IN ('view', 'edit')),
  PRIMARY KEY (task_id, shared_with)
);
```

---

## 📚 Resources

- **Supabase SQL Docs**: https://supabase.com/docs/guides/database/overview
- **PostgreSQL Tutorial**: https://www.postgresqltutorial.com/
- **SQL Cheat Sheet**: https://www.postgresqltutorial.com/postgresql-cheat-sheet/
- **Supabase Flutter**: https://supabase.com/docs/reference/dart/introduction

---

*Schema Version: 2.0 - Simplified for Workshop | Updated: November 21, 2025*

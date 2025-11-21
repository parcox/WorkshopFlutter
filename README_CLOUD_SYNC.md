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

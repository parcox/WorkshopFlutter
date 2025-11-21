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

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/app/models/task.dart';

class StorageService {
  // Storage key
  static const String tasksKey = 'tasks';

  // Get SharedPreferences instance
  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  /// Save tasks to storage
  Future<bool> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await _prefs;

      // Convert List<Task> ke List<Map>
      List<Map<String, dynamic>> tasksJson =
        tasks.map((task) => task.toJson()).toList();

      // Convert List<Map> ke JSON string
      String tasksString = jsonEncode(tasksJson);

      // Save ke SharedPreferences
      bool result = await prefs.setString(tasksKey, tasksString);

      print('✅ Saved ${tasks.length} tasks to storage');
      return result;
    } catch (e) {
      print('❌ Error saving tasks: $e');
      return false;
    }
  }

  /// Load tasks from storage
  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await _prefs;

      // Get JSON string dari SharedPreferences
      String? tasksString = prefs.getString(tasksKey);

      // Jika null, return empty list
      if (tasksString == null || tasksString.isEmpty) {
        print('ℹ️ No tasks in storage');
        return [];
      }

      // Convert JSON string ke List<dynamic>
      List<dynamic> tasksJson = jsonDecode(tasksString);

      // Convert List<dynamic> ke List<Task>
      List<Task> tasks = tasksJson
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();

      print('✅ Loaded ${tasks.length} tasks from storage');
      return tasks;
    } catch (e) {
      print('❌ Error loading tasks: $e');
      return [];
    }
  }

  /// Clear all tasks from storage
  Future<bool> clearTasks() async {
    try {
      final prefs = await _prefs;
      bool result = await prefs.remove(tasksKey);

      print('✅ Cleared tasks from storage');
      return result;
    } catch (e) {
      print('❌ Error clearing tasks: $e');
      return false;
    }
  }

  /// Check if tasks exist in storage
  Future<bool> hasTasks() async {
    final prefs = await _prefs;
    return prefs.containsKey(tasksKey);
  }
}

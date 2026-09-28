import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

/// Persists tasks and settings on the device.
class TaskStorage {
  static const _tasksKey = 'tasks';
  static const _darkModeKey = 'dark_mode';

  final SharedPreferences _prefs;

  TaskStorage._(this._prefs);

  static Future<TaskStorage> create() async {
    return TaskStorage._(await SharedPreferences.getInstance());
  }

  /// Returns the saved tasks, or the sample tasks on first launch.
  List<Task> loadTasks() {
    final raw = _prefs.getString(_tasksKey);
    if (raw == null) {
      return getSampleTasks();
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return getSampleTasks();
    } on TypeError {
      return getSampleTasks();
    }
  }

  Future<void> saveTasks(List<Task> tasks) {
    return _prefs.setString(
      _tasksKey,
      jsonEncode(tasks.map((t) => t.toJson()).toList()),
    );
  }

  bool loadDarkMode() => _prefs.getBool(_darkModeKey) ?? false;

  Future<void> saveDarkMode(bool value) => _prefs.setBool(_darkModeKey, value);
}

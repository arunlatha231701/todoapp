import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get highPriorityTasks => _tasks.where((task) => task.priority == Priority.high).toList();
  List<Task> get todayTasks => _tasks.where((task) => task.isDueToday).toList();
  List<Task> get overdueTasks => _tasks.where((task) => task.isOverdue).toList();


  Future<void> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList('tasks');

      if (tasksJson != null) {
        _tasks.clear();
        for (final taskJson in tasksJson) {
          try {
            final taskMap = jsonDecode(taskJson) as Map<String, dynamic>;
            _tasks.add(Task.fromMap(taskMap));
          } catch (e) {

            debugPrint('Failed to parse task: $e');
          }
        }

        _tasks.sort((a, b) {
          if (a.isCompleted != b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          }
          return b.createdAt.compareTo(a.createdAt);
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load tasks: $e');

      rethrow;
    }
  }


  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = _tasks.map((task) => jsonEncode(task.toMap())).toList();
      await prefs.setStringList('tasks', tasksJson);
    } catch (e) {
      debugPrint('Failed to save tasks: $e');
      rethrow;
    }
  }


  void addTask({
    required String title,
    String description = '',
    DateTime? dueDate,
    Priority priority = Priority.none,
    Category category = Category.other,
    List<String> tags = const [],
    bool hasReminder = false,
    DateTime? reminderDate,
  }) {
    try {
      if (title.trim().isEmpty) {
        throw ArgumentError('Task title cannot be empty');
      }

      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        description: description.trim(),
        createdAt: DateTime.now(),
        dueDate: dueDate,
        priority: priority,
        category: category,
        tags: tags,
        hasReminder: hasReminder,
        reminderDate: reminderDate,
      );

      _tasks.insert(0, task);
      notifyListeners();
      _saveTasks();
    } catch (e) {
      debugPrint('Failed to add task: $e');
      rethrow;
    }
  }


  void toggleTaskCompletion(String id) {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex >= 0) {
        _tasks[taskIndex].toggleComplete();


        if (_tasks[taskIndex].isCompleted) {
          final completedTask = _tasks.removeAt(taskIndex);
          _tasks.add(completedTask);
        } else {
          final pendingTask = _tasks.removeAt(taskIndex);
          _tasks.insert(0, pendingTask);
        }

        notifyListeners();
        _saveTasks();
      }
    } catch (e) {
      debugPrint('Failed to toggle task completion: $e');
      rethrow;
    }
  }

  void deleteTask(String id) {
    try {
      final initialLength = _tasks.length;
      _tasks.removeWhere((task) => task.id == id);

      if (_tasks.length != initialLength) {
        notifyListeners();
        _saveTasks();
      }
    } catch (e) {
      debugPrint('Failed to delete task: $e');
      rethrow;
    }
  }


  void updateTask({
    required String id,
    required String newTitle,
    required String newDescription,
    DateTime? dueDate,
    Priority priority = Priority.none,
    Category category = Category.other,
    List<String> tags = const [],
    bool hasReminder = false,
    DateTime? reminderDate,
  }) {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex >= 0) {
        final oldTask = _tasks[taskIndex];
        _tasks[taskIndex] = oldTask.copyWith(
          title: newTitle.trim(),
          description: newDescription.trim(),
          dueDate: dueDate,
          priority: priority,
          category: category,
          tags: tags,
          hasReminder: hasReminder,
          reminderDate: reminderDate,
        );
        notifyListeners();
        _saveTasks();
      }
    } catch (e) {
      debugPrint('Failed to update task: $e');
      rethrow;
    }
  }


  void clearCompletedTasks() {
    try {
      final initialLength = _tasks.length;
      _tasks.removeWhere((task) => task.isCompleted);

      if (_tasks.length != initialLength) {
        notifyListeners();
        _saveTasks();
      }
    } catch (e) {
      debugPrint('Failed to clear completed tasks: $e');
      rethrow;
    }
  }


  List<Task> getTasksByCategory(Category category) {
    return _tasks.where((task) => task.category == category).toList();
  }


  List<Task> getTasksByPriority(Priority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }


  List<Task> searchTasks(String query) {
    if (query.isEmpty) return _tasks;

    final lowercaseQuery = query.toLowerCase();
    return _tasks.where((task) =>
    task.title.toLowerCase().contains(lowercaseQuery) ||
        task.description.toLowerCase().contains(lowercaseQuery) ||
        task.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }
}
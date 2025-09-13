import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task should toggle completion status', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime.now(),
      );

      expect(task.isCompleted, false);
      task.toggleComplete();
      expect(task.isCompleted, true);
      task.toggleComplete();
      expect(task.isCompleted, false);
    });

    test('Task should convert to and from map correctly', () {
      final now = DateTime.now();
      final originalTask = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: now,
        dueDate: now.add(const Duration(days: 1)),
        priority: Priority.high,
        category: Category.work,
        tags: ['urgent'],
        hasReminder: true,
        reminderDate: now.add(const Duration(hours: 1)),
      );

      final map = originalTask.toMap();
      final reconstructedTask = Task.fromMap(map);

      expect(reconstructedTask.id, originalTask.id);
      expect(reconstructedTask.title, originalTask.title);
      expect(reconstructedTask.description, originalTask.description);
      expect(reconstructedTask.isCompleted, originalTask.isCompleted);
      expect(reconstructedTask.createdAt, originalTask.createdAt);
      expect(reconstructedTask.dueDate, originalTask.dueDate);
      expect(reconstructedTask.priority, originalTask.priority);
      expect(reconstructedTask.category, originalTask.category);
      expect(reconstructedTask.tags, originalTask.tags);
      expect(reconstructedTask.hasReminder, originalTask.hasReminder);
      expect(reconstructedTask.reminderDate, originalTask.reminderDate);
    });

    test('Task equality should work based on ID', () {
      final task1 = Task(
        id: '1',
        title: 'Task 1',
        description: 'Desc 1',
        createdAt: DateTime.now(),
      );

      final task2 = Task(
        id: '1',
        title: 'Task 2',
        description: 'Desc 2',
        createdAt: DateTime.now(),
      );

      final task3 = Task(
        id: '2',
        title: 'Task 1',
        description: 'Desc 1',
        createdAt: DateTime.now(),
      );

      expect(task1 == task2, true);
      expect(task1 == task3, false);
    });

    test('Task should return correct formatted values', () {
      final dueDate = DateTime(2023, 12, 25);
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime.now(),
        dueDate: dueDate,
        priority: Priority.high,
        category: Category.work,
      );

      expect(task.formattedDueDate, 'Dec 25, 2023');
      expect(task.formattedPriority, 'High');
      expect(task.formattedCategory, 'Work');
    });
  });
}
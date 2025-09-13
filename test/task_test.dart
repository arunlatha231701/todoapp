import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task should be created with correct default values', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime(2023, 1, 1),
      );

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.isCompleted, false);
      expect(task.dueDate, isNull);
      expect(task.priority, Priority.none);
      expect(task.category, Category.other);
      expect(task.tags, isEmpty);
      expect(task.hasReminder, false);
      expect(task.reminderDate, isNull);
    });

    test('Task toggleComplete should change completion status', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime(2023, 1, 1),
      );

      expect(task.isCompleted, false);
      task.toggleComplete();
      expect(task.isCompleted, true);
      task.toggleComplete();
      expect(task.isCompleted, false);
    });

    test('Task should correctly identify overdue status', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime(2023, 1, 1),
        dueDate: yesterday,
      );

      expect(task.isOverdue, true);
      expect(task.isDueToday, false);
    });

    test('Task should correctly identify due today status', () {
      final today = DateTime.now();
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime(2023, 1, 1),
        dueDate: today,
      );

      expect(task.isOverdue, false);
      expect(task.isDueToday, true);
    });

    test('Task should serialize and deserialize correctly', () {
      final originalTask = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: true,
        createdAt: DateTime(2023, 1, 1, 10, 30),
        dueDate: DateTime(2023, 1, 2),
        priority: Priority.high,
        category: Category.work,
        tags: ['urgent', 'important'],
        hasReminder: true,
        reminderDate: DateTime(2023, 1, 1, 9, 0),
      );

      final taskMap = originalTask.toMap();
      final restoredTask = Task.fromMap(taskMap);

      expect(restoredTask.id, originalTask.id);
      expect(restoredTask.title, originalTask.title);
      expect(restoredTask.description, originalTask.description);
      expect(restoredTask.isCompleted, originalTask.isCompleted);
      expect(restoredTask.createdAt, originalTask.createdAt);
      expect(restoredTask.dueDate, originalTask.dueDate);
      expect(restoredTask.priority, originalTask.priority);
      expect(restoredTask.category, originalTask.category);
      expect(restoredTask.tags, originalTask.tags);
      expect(restoredTask.hasReminder, originalTask.hasReminder);
      expect(restoredTask.reminderDate, originalTask.reminderDate);
    });

    test('Task copyWith should create a copy with updated fields', () {
      final originalTask = Task(
        id: '1',
        title: 'Original Task',
        description: 'Original Description',
        createdAt: DateTime(2023, 1, 1),
      );

      final copiedTask = originalTask.copyWith(
        title: 'Updated Task',
        description: 'Updated Description',
        isCompleted: true,
      );

      expect(copiedTask.id, originalTask.id);
      expect(copiedTask.title, 'Updated Task');
      expect(copiedTask.description, 'Updated Description');
      expect(copiedTask.isCompleted, true);
      expect(copiedTask.createdAt, originalTask.createdAt);
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/providers/task_provider.dart';

void main() {
  group('TaskProvider Tests', () {
    test('Add task with all parameters', () {
      final taskProvider = TaskProvider();
      final dueDate = DateTime.now().add(const Duration(days: 1));

      taskProvider.addTask(
        title: 'Test Task',
        description: 'Test Description',
        dueDate: dueDate,
        priority: Priority.high,
        category: Category.work,
        tags: ['urgent', 'important'],
        hasReminder: true,
        reminderDate: dueDate,
      );

      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0].title, 'Test Task');
      expect(taskProvider.tasks[0].priority, Priority.high);
      expect(taskProvider.tasks[0].category, Category.work);
      expect(taskProvider.tasks[0].tags, ['urgent', 'important']);
      expect(taskProvider.tasks[0].hasReminder, true);
    });

    test('Toggle task completion', () {
      final taskProvider = TaskProvider();
      taskProvider.addTask(title: 'Test Task', description: 'Test Description');

      expect(taskProvider.tasks[0].isCompleted, false);
      taskProvider.toggleTaskCompletion(taskProvider.tasks[0].id);
      expect(taskProvider.tasks[0].isCompleted, true);
    });

    test('Delete task', () {
      final taskProvider = TaskProvider();
      taskProvider.addTask(title: 'Test Task', description: 'Test Description');

      expect(taskProvider.tasks.length, 1);
      taskProvider.deleteTask(taskProvider.tasks[0].id);
      expect(taskProvider.tasks.length, 0);
    });

    test('Update task', () {
      final taskProvider = TaskProvider();
      taskProvider.addTask(title: 'Old Title', description: 'Old Description');

      taskProvider.updateTask(
        id: taskProvider.tasks[0].id,
        newTitle: 'New Title',
        newDescription: 'New Description',
        priority: Priority.medium,
      );

      expect(taskProvider.tasks[0].title, 'New Title');
      expect(taskProvider.tasks[0].description, 'New Description');
      expect(taskProvider.tasks[0].priority, Priority.medium);
    });

    test('Filter tasks by category', () {
      final taskProvider = TaskProvider();
      taskProvider.addTask(title: 'Work Task', description: '', category: Category.work);
      taskProvider.addTask(title: 'Personal Task', description: '', category: Category.personal);

      final workTasks = taskProvider.getTasksByCategory(Category.work);
      expect(workTasks.length, 1);
      expect(workTasks[0].title, 'Work Task');
    });

    test('Search tasks', () {
      final taskProvider = TaskProvider();
      taskProvider.addTask(title: 'Buy groceries', description: 'Milk, eggs, bread', tags: ['shopping']);
      taskProvider.addTask(title: 'Finish report', description: 'Quarterly financial report');

      final results = taskProvider.searchTasks('groceries');
      expect(results.length, 1);
      expect(results[0].title, 'Buy groceries');
    });
  });
}
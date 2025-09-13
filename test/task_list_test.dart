import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:todoapp/widgets/task_list.dart';

void main() {
  testWidgets('TaskList displays tasks correctly', (WidgetTester tester) async {
    final taskProvider = TaskProvider();

    // Add test tasks using the new named parameters
    taskProvider.addTask(
        title: 'Test Task 1',
        description: 'Description 1'
    );
    taskProvider.addTask(
        title: 'Test Task 2',
        description: 'Description 2'
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: taskProvider,
        child: MaterialApp(
          home: Scaffold(body: TaskList(tasks: taskProvider.tasks)),
        ),
      ),
    );

    // Verify tasks are displayed
    expect(find.text('Test Task 1'), findsOneWidget);
    expect(find.text('Test Task 2'), findsOneWidget);
    expect(find.text('Description 1'), findsOneWidget);
    expect(find.text('Description 2'), findsOneWidget);
  });

  testWidgets('TaskList shows empty state when no tasks', (WidgetTester tester) async {
    final taskProvider = TaskProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: taskProvider,
        child: MaterialApp(
          home: Scaffold(body: TaskList(tasks: taskProvider.tasks)),
        ),
      ),
    );

    expect(find.text('No tasks found!'), findsOneWidget);
    expect(find.text('Try changing your filters or add a new task.'), findsOneWidget);
  });

  testWidgets('TaskList shows filtered tasks', (WidgetTester tester) async {
    final taskProvider = TaskProvider();

    // Add test tasks
    taskProvider.addTask(title: 'Test Task 1', description: 'Description 1');
    taskProvider.addTask(title: 'Test Task 2', description: 'Description 2');

    // Create a filtered list with just one task
    final filteredTasks = [taskProvider.tasks[0]];

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: taskProvider,
        child: MaterialApp(
          home: Scaffold(body: TaskList(tasks: filteredTasks)),
        ),
      ),
    );

    // Verify only the filtered task is displayed
    expect(find.text('Test Task 1'), findsOneWidget);
    expect(find.text('Test Task 2'), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:todoapp/widgets/task_tile.dart';


class MockTaskProvider extends TaskProvider {
  Function(String)? onToggleTaskCompletion;

  @override
  void toggleTaskCompletion(String id) {
    onToggleTaskCompletion?.call(id);
  }

  @override
  void notifyListeners() {}
}

void main() {
  testWidgets('TaskTile displays task information correctly', (WidgetTester tester) async {
    final testTask = Task(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
      isCompleted: false,
      priority: Priority.high,
      category: Category.work,
      tags: ['urgent', 'important'],
      dueDate: DateTime.now(),
      hasReminder: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>(
          create: (context) => MockTaskProvider(),
          child: Scaffold(
            body: TaskTile(task: testTask),
          ),
        ),
      ),
    );


    expect(find.text('Test Task'), findsOneWidget);

    expect(find.text('Test Description'), findsOneWidget);

    expect(find.text('High'), findsOneWidget);


    expect(find.text('Work'), findsOneWidget);


    expect(find.text('urgent'), findsOneWidget);
    expect(find.text('important'), findsOneWidget);


    expect(find.byType(Checkbox), findsOneWidget);


    expect(find.byIcon(Icons.edit), findsOneWidget);
  });

  testWidgets('TaskTile shows completed task with strikethrough', (WidgetTester tester) async {
    final completedTask = Task(
      id: '2',
      title: 'Completed Task',
      description: 'Completed Description',
      isCompleted: true,
      priority: Priority.medium,
      category: Category.personal,
      tags: [],
      dueDate: null,
      hasReminder: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>(
          create: (context) => MockTaskProvider(),
          child: Scaffold(
            body: TaskTile(task: completedTask),
          ),
        ),
      ),
    );

    final titleFinder = find.text('Completed Task');
    final titleWidget = tester.widget<Text>(titleFinder);

    expect(titleWidget.style?.color, Colors.grey);
  });

  testWidgets('TaskTile handles checkbox tap', (WidgetTester tester) async {
    bool toggleCalled = false;
    String? calledWithId;

    final mockProvider = MockTaskProvider();
    mockProvider.onToggleTaskCompletion = (id) {
      toggleCalled = true;
      calledWithId = id;
    };

    final testTask = Task(
      id: '3',
      title: 'Tappable Task',
      description: 'Test',
      isCompleted: false,
      priority: Priority.low,
      category: Category.study,
      tags: [],
      dueDate: null,
      hasReminder: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>(
          create: (context) => mockProvider,
          child: Scaffold(
            body: TaskTile(task: testTask),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(toggleCalled, true);
    expect(calledWithId, '3');
  });

  testWidgets('TaskTile shows limited tags with more indicator', (WidgetTester tester) async {
    final taskWithManyTags = Task(
      id: '4',
      title: 'Multi-tag Task',
      description: 'Test',
      isCompleted: false,
      priority: Priority.none,
      category: Category.other,
      tags: ['tag1', 'tag2', 'tag3', 'tag4', 'tag5'],
      dueDate: null,
      hasReminder: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>(
          create: (context) => MockTaskProvider(),
          child: Scaffold(
            body: TaskTile(task: taskWithManyTags),
          ),
        ),
      ),
    );


    expect(find.text('tag1'), findsOneWidget);
    expect(find.text('tag2'), findsOneWidget);

    expect(find.text('+3 more'), findsOneWidget);

    expect(find.text('tag3'), findsNothing);
    expect(find.text('tag4'), findsNothing);
    expect(find.text('tag5'), findsNothing);
  });
}
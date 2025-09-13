import 'package:intl/intl.dart';

enum Priority { none, low, medium, high }
enum Category { personal, work, study, health, shopping, other }

class Task {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final Priority priority;
  final Category category;
  final List<String> tags;
  final bool hasReminder;
  final DateTime? reminderDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = Priority.none,
    this.category = Category.other,
    this.tags = const [],
    this.hasReminder = false,
    this.reminderDate,
  });

  void toggleComplete() {
    isCompleted = !isCompleted;
  }

  String get formattedDueDate {
    if (dueDate == null) return 'No due date';
    return DateFormat('MMM dd, yyyy').format(dueDate!);
  }

  String get formattedPriority {
    switch (priority) {
      case Priority.none:
        return 'None';
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }

  String get formattedCategory {
    switch (category) {
      case Category.personal:
        return 'Personal';
      case Category.work:
        return 'Work';
      case Category.study:
        return 'Study';
      case Category.health:
        return 'Health';
      case Category.shopping:
        return 'Shopping';
      case Category.other:
        return 'Other';
    }
  }


  bool get isOverdue {
    if (dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now()) && !isCompleted;
  }


  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day &&
        !isCompleted;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.index,
      'category': category.index,
      'tags': tags,
      'hasReminder': hasReminder,
      'reminderDate': reminderDate?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    try {
      return Task(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        isCompleted: map['isCompleted'] as bool,
        createdAt: DateTime.parse(map['createdAt'] as String),
        dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate'] as String) : null,
        priority: Priority.values[map['priority'] as int],
        category: Category.values[map['category'] as int],
        tags: List<String>.from(map['tags'] as List),
        hasReminder: map['hasReminder'] as bool,
        reminderDate: map['reminderDate'] != null ? DateTime.parse(map['reminderDate'] as String) : null,
      );
    } catch (e) {
      throw const FormatException('Invalid task data format');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Task &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    Priority? priority,
    Category? category,
    List<String>? tags,
    bool? hasReminder,
    DateTime? reminderDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderDate: reminderDate ?? this.reminderDate,
    );
  }
}
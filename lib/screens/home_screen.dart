import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_stats.dart';
import '../widgets/category_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentFilterIndex = 0;
  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Completed',
    'High Priority',
    'Today',
    'Overdue',
  ];

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final theme = Theme.of(context);

    List<Task> filteredTasks;
    switch (_currentFilterIndex) {
      case 0:
        filteredTasks = taskProvider.tasks;
        break;
      case 1:
        filteredTasks = taskProvider.pendingTasks;
        break;
      case 2:
        filteredTasks = taskProvider.completedTasks;
        break;
      case 3:
        filteredTasks = taskProvider.highPriorityTasks;
        break;
      case 4:
        filteredTasks = taskProvider.todayTasks;
        break;
      case 5:
        filteredTasks = taskProvider.overdueTasks;
        break;
      default:
        filteredTasks = taskProvider.tasks;
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => CategoryFilter(
                  currentIndex: _currentFilterIndex,
                  onFilterSelected: (index) {
                    setState(() {
                      _currentFilterIndex = index;
                    });
                    Navigator.pop(context);
                  },
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              );
            },
            tooltip: 'Filter Tasks',
          ),
          if (taskProvider.completedTasks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                _showClearCompletedDialog(context, taskProvider);
              },
              tooltip: 'Clear Completed',
            ),
        ],
      ),
      body: Column(
        children: [
          const TaskStats(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Chip(
                  label: Text(_filterOptions[_currentFilterIndex]),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  labelStyle: TextStyle(color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 8),
                Text(
                  '${filteredTasks.length} task${filteredTasks.length != 1 ? 's' : ''}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const Spacer(),
                if (filteredTasks.isNotEmpty)
                  TextButton(
                    onPressed: () {},
                    child: const Text('Scroll to Top'),
                  ),
              ],
            ),
          ),
          Expanded(child: TaskList(tasks: filteredTasks)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddTaskDialog(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showClearCompletedDialog(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed Tasks'),
        content: Text(
          'Are you sure you want to delete ${taskProvider.completedTasks.length} completed task${taskProvider.completedTasks.length != 1 ? 's' : ''}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              taskProvider.clearCompletedTasks();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Cleared ${taskProvider.completedTasks.length} completed tasks',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

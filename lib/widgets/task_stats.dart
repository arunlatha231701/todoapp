import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskStats extends StatelessWidget {
  const TaskStats({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final totalTasks = taskProvider.tasks.length;
    final completedTasks = taskProvider.completedTasks.length;
    final pendingTasks = taskProvider.pendingTasks.length;
    final highPriorityTasks = taskProvider.highPriorityTasks.length;
    final todayTasks = taskProvider.todayTasks.length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total', totalTasks, Colors.blue),
              _buildStatItem('Completed', completedTasks, Colors.green),
              _buildStatItem('Pending', pendingTasks, Colors.orange),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('High Priority', highPriorityTasks, Colors.red),
              _buildStatItem('Due Today', todayTasks, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
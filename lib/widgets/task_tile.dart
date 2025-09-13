import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'edit_task_dialog.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => taskProvider.toggleTaskCompletion(task.id),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : theme.colorScheme.onSurface,
            fontWeight: task.priority == Priority.high ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  task.description,
                  style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted ? Colors.grey : Colors.grey[700],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (task.dueDate != null)
                  _buildDueDateChip(task.dueDate!),
                if (task.priority != Priority.none)
                  _buildPriorityChip(task.priority),
                _buildCategoryChip(task.category),
                ...task.tags.take(2).map((tag) => _buildTagChip(tag)),
                if (task.tags.length > 2)
                  _buildMoreTagsChip(task.tags.length - 2),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, size: 20, color: theme.colorScheme.primary),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => EditTaskDialog(task: task),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            );
          },
        ),
        onTap: () => taskProvider.toggleTaskCompletion(task.id),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildDueDateChip(DateTime dueDate) {
    return Chip(
      label: Text(
        task.formattedDueDate,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor: _getDueDateColor(dueDate),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _buildPriorityChip(Priority priority) {
    return Chip(
      label: Text(
        task.formattedPriority,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor: _getPriorityColor(priority),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _buildCategoryChip(Category category) {
    return Chip(
      label: Text(
        task.formattedCategory,
        style: const TextStyle(fontSize: 10),
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.grey[300],
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _buildTagChip(String tag) {
    return Chip(
      label: Text(
        tag,
        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.grey[200],
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _buildMoreTagsChip(int count) {
    return Chip(
      label: Text(
        '+$count more',
        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.grey[100],
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.blue;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
      case Priority.none:
        return Colors.grey;
    }
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (dueDate.isBefore(now)) {
      return Colors.red;
    } else if (difference.inDays == 0) {
      return Colors.orange;
    } else if (difference.inDays <= 2) {
      return Colors.amber[700]!;
    } else {
      return Colors.green;
    }
  }
}
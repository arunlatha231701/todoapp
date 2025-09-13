import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  DateTime? _dueDate;
  Priority _priority = Priority.none;
  Category _category = Category.other;
  List<String> _tags = [];
  final _tagController = TextEditingController();
  bool _hasReminder = false;
  DateTime? _reminderDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Task',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title*',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDueDateSelector(),
            const SizedBox(height: 16),
            _buildPrioritySelector(),
            const SizedBox(height: 16),
            _buildCategorySelector(),
            const SizedBox(height: 16),
            _buildTagsSelector(),
            const SizedBox(height: 16),
            _buildReminderSelector(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        taskProvider.addTask(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          dueDate: _dueDate,
                          priority: _priority,
                          category: _category,
                          tags: _tags,
                          hasReminder: _hasReminder,
                          reminderDate: _reminderDate,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add Task'),
                  ),
                ),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDateSelector() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 20),
        const SizedBox(width: 16),
        const Text('Due Date:'),
        const Spacer(),
        TextButton(
          onPressed: () async {

            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );

            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (selectedDate != null) {
              setState(() {
                _dueDate = selectedDate;
              });
            }
          },
          child: Text(
            _dueDate != null
                ? DateFormat('MMM dd, yyyy').format(_dueDate!)
                : 'Select date',
          ),
        ),
        if (_dueDate != null)
          IconButton(
            icon: const Icon(Icons.clear, size: 16),
            onPressed: () {
              setState(() {
                _dueDate = null;
              });
            },
          ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: [
        const Icon(Icons.flag, size: 20),
        const SizedBox(width: 16),
        const Text('Priority:'),
        const Spacer(),
        DropdownButton<Priority>(
          value: _priority,
          onChanged: (Priority? newValue) {
            setState(() {
              _priority = newValue ?? Priority.none;
            });
          },
          items: Priority.values.map((Priority priority) {
            return DropdownMenuItem<Priority>(
              value: priority,
              child: Text(_getPriorityText(priority)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Row(
      children: [
        const Icon(Icons.category, size: 20),
        const SizedBox(width: 16),
        const Text('Category:'),
        const Spacer(),
        DropdownButton<Category>(
          value: _category,
          onChanged: (Category? newValue) {
            setState(() {
              _category = newValue ?? Category.other;
            });
          },
          items: Category.values.map((Category category) {
            return DropdownMenuItem<Category>(
              value: category,
              child: Text(_getCategoryText(category)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTagsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tags:'),
        Wrap(
          spacing: 8,
          children: _tags.map((tag) => Chip(
            label: Text(tag),
            onDeleted: () {
              setState(() {
                _tags.remove(tag);
              });
            },
          )).toList(),
        ),
        TextField(
          controller: _tagController,
          decoration: InputDecoration(
            hintText: 'Add tag and press enter',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (_tagController.text.trim().isNotEmpty) {
                  setState(() {
                    _tags.add(_tagController.text.trim());
                    _tagController.clear();
                  });
                }
              },
            ),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              setState(() {
                _tags.add(value.trim());
                _tagController.clear();
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildReminderSelector() {
    return Row(
      children: [
        const Icon(Icons.notifications, size: 20),
        const SizedBox(width: 16),
        const Text('Reminder:'),
        const Spacer(),
        Switch(
          value: _hasReminder,
          onChanged: (value) async {
            if (value) {

              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );

              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(hours: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (selectedDate != null) {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1))),
                );
                if (selectedTime != null) {
                  setState(() {
                    _hasReminder = true;
                    _reminderDate = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                  });
                }
              }
            } else {
              setState(() {
                _hasReminder = false;
                _reminderDate = null;
              });
            }
          },
        ),
        if (_hasReminder && _reminderDate != null)
          Text(DateFormat('MMM dd, HH:mm').format(_reminderDate!)),
      ],
    );
  }

  String _getPriorityText(Priority priority) {
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

  String _getCategoryText(Category category) {
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
}
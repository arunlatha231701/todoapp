import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onFilterSelected;

  const CategoryFilter({
    super.key,
    required this.currentIndex,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Pending', 'Completed', 'High Priority', 'Today'];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Filter Tasks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: filters.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filters[index]),
                trailing: currentIndex == index
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  onFilterSelected(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
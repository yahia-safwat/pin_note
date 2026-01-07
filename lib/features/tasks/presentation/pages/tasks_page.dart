import 'package:flutter/material.dart';

class TaskItem {
  final String title;
  final String date;
  final bool isCompleted;

  TaskItem({required this.title, required this.date, this.isCompleted = false});
}

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  static final List<TaskItem> mockTasks = [
    TaskItem(title: 'Grocery shopping', date: 'Tomorrow, 10:00 AM'),
    TaskItem(
      title: 'Call the dentist',
      date: 'Today, 2:30 PM',
      isCompleted: true,
    ),
    TaskItem(title: 'Finish Flutter project', date: 'Jan 10, 2026'),
    TaskItem(title: 'Gym workout', date: 'Mondays & Thursdays'),
    TaskItem(title: 'Pay electric bill', date: 'Due in 3 days'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: mockTasks.length,
        itemBuilder: (context, index) {
          final task = mockTasks[index];
          return ListTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (val) {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
                color: task.isCompleted ? Colors.grey : null,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              task.date,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            trailing: const Icon(Icons.more_vert, size: 20),
            onTap: () {},
          );
        },
      ),
    );
  }
}

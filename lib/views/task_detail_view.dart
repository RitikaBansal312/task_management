import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskDetailView extends StatelessWidget {
  final Task task;

  TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: task.title.isEmpty
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Created on: ${task.createdAt}'),
                  const SizedBox(height: 20),
                  Text('Description:', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text(task.description),
                  if (task.imageUrl.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Image.network(task.imageUrl),
                  ],
                ],
              ),
      ),
    );
  }
}

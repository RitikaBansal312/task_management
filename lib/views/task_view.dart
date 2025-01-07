import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import 'add_task_view.dart';

class TaskView extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Obx(() {
        if (taskController.tasks.isEmpty) {
          return const Center(child: Text('No tasks available.'));
        }
        return ListView.builder(
          itemCount: taskController.tasks.length,
          itemBuilder: (context, index) {
            final task = taskController.tasks[index];
            return ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  taskController.updateTaskStatus(task.id, value ?? false);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddTaskView()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

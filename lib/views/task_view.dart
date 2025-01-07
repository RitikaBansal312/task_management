import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import 'add_task_view.dart';
import 'task_detail_view.dart';

class TaskView extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          // Display version in the app bar
           FutureBuilder(
            future: taskController.getAppVersion(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text(
                    "Loading version...",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text(
                    "Error loading version",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              } else {
                 return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    "v${taskController.version}",
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (taskController.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        return ListView.builder(
          itemCount: taskController.tasks.length,
          itemBuilder: (context, index) {
            final task = taskController.tasks[index];
            return Dismissible(
              key: Key(task.id),
              onDismissed: (direction) {
                taskController.deleteTask(task.id);
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                onTap: () => Get.to(() => TaskDetailView(task: task)),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    taskController.updateTaskStatus(task.id, value ?? false);
                  },
                ),
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

// views/task_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              taskController.version.isNotEmpty
                  ? "v${taskController.version}"
                  : "Loading version...",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (taskController.tasks.isEmpty) {
          return const Center(child: Text('No tasks available.'));
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
                title: Text(task.title),
                onTap: () => Get.to(() => TaskDetailView(task: task)),
              ),
            );
            // return Slidable(
            //   actionPane: const SlidableDrawerActionPane(),
            //   actionExtentRatio: 0.25,
            //   child: ListTile(
            //     title: Text(
            //       task.title,
            //       style: TextStyle(
            //         decoration:
            //             task.isCompleted ? TextDecoration.lineThrough : null,
            //       ),
            //     ),
            //     onTap: () => Get.to(() => TaskDetailView(task: task)),
            //   ),
            //   secondaryActions: [
            //     IconSlideAction(
            //       caption: 'Delete', // Use 'label' instead of 'caption'
            //       color: Colors.red,
            //       icon: Icons.delete,
            //       onTap: () async {
            //         final shouldDelete = await showDialog<bool>(
            //           context: context,
            //           builder: (context) => AlertDialog(
            //             title: const Text('Delete Task'),
            //             content: const Text(
            //                 'Are you sure you want to delete this task?'),
            //             actions: <Widget>[
            //               TextButton(
            //                 onPressed: () => Get.back(result: false),
            //                 child: const Text('Cancel'),
            //               ),
            //               TextButton(
            //                 onPressed: () => Get.back(result: true),
            //                 child: const Text('Delete'),
            //               ),
            //             ],
            //           ),
            //         );
            //         if (shouldDelete == true) {
            //           taskController.deleteTask(task.id);
            //         }
            //       },
            //     ),
            //   ],
            // );
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

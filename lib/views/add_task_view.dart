import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class AddTaskView extends StatefulWidget {
  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final TextEditingController titleController = TextEditingController();
  // final TextEditingController descriptionController = TextEditingController();
  final quill.QuillController _controller = quill.QuillController.basic();
  final TaskController taskController = Get.find();
  File? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              const SizedBox(height: 10),
              Container(
                child: Column(
                  children: [
                    quill.QuillToolbar.simple(controller: _controller),
                    quill.QuillEditor.basic(
                      controller: _controller,
                      scrollController: ScrollController(),
                      focusNode: FocusNode(),
                    ),
                  ],
                ),
              ),
              // TextField(
              //   controller: descriptionController,
              //   decoration:
              //       const InputDecoration(labelText: 'Task Description'),
              //   maxLines: 5,
              // ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              if (_imageFile != null) Image.file(_imageFile!),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    taskController.addTask(
                      titleController.text.trim(),
                      _controller.document.toDelta().toJson().toList(),
                      _imageFile,
                    );
                    Get.back();
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

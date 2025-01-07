import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

class TaskController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var tasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  void fetchTasks() {
    _firebaseService.getTasks().listen((taskList) {
      tasks.value = taskList.reversed.toList();
    });
  }

  Future<void> addTask(String title) async {
    final task = Task(id: '', title: title);
    await _firebaseService.addTask(task);
  }

  Future<void> updateTaskStatus(String id, bool isCompleted) async {
    await _firebaseService.updateTaskStatus(id, isCompleted);
  }
}

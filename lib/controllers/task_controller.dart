import 'dart:io';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

class TaskController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var tasks = <Task>[].obs;
  String version = "";
  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  // Fetch the version dynamically
  Future getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    print(version); // Get the app version
    return version;
  }

  void fetchTasks() {
    _firebaseService.getTasks().listen((taskList) {
      tasks.value = taskList.reversed.toList();
    });
  }

  Future<void> addTask(String title, List description, File? imageFile) async {
    String imageUrl = '';
    if (imageFile != null) {
      imageUrl = await _firebaseService.uploadImage(imageFile);
    }
    final task = Task(
      id: '',
      title: title,
      description: description.map((item) => item['insert'] ?? '').join(),
      // description[0]["insert"].toString(),
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    await _firebaseService.addTask(task);
  }

  Future<void> updateTaskStatus(String id, bool isCompleted) async {
    await _firebaseService.updateTaskStatus(id, isCompleted);
  }

  Future<void> deleteTask(String id) async {
    await _firebaseService.deleteTask(id);
  }
}

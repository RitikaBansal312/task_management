import 'package:firebase_database/firebase_database.dart';
import '../models/task_model.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('tasks');

  Future<void> addTask(Task task) async {
    await _db.push().set(task.toMap());
  }

  Future<void> updateTaskStatus(String id, bool isCompleted) async {
    await _db.child(id).update({'isCompleted': isCompleted});
  }

  Stream<List<Task>> getTasks() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries.map((e) => Task.fromMap(e.key, e.value)).toList();
    });
  }
}

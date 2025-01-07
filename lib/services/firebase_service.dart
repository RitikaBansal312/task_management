import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import '../models/task_model.dart' as task_model;

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('tasks');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('task_images/$fileName');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw PlatformException(code: 'UPLOAD_FAILED', message: e.toString());
    }
  }

  Future<void> addTask(task_model.Task task) async {
    await _db.push().set(task.toMap());
  }

  Future<void> updateTaskStatus(String id, bool isCompleted) async {
    await _db.child(id).update({'isCompleted': isCompleted});
  }

  Stream<List<task_model.Task>> getTasks() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries.map((e) => task_model.Task.fromMap(e.key, e.value)).toList();
    });
  }

  Future<void> deleteTask(String id) async {
    await _db.child(id).remove();
  }
}

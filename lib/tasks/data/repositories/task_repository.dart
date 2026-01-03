import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

abstract class TaskRepository {
  Stream<List<TaskModel>> watchTasksForTrip({
    required String userId,
    required String tripId,
  });

  Future<TaskModel> createTask({
    required String userId,
    required String tripId,
    required String title,
  });

  Future<void> setCompleted({
    required String taskId,
    required bool isCompleted,
  });

  Future<void> deleteTask(String taskId);
}

class FirestoreTaskRepository implements TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _tasks => _firestore.collection('tasks');

  @override
  Stream<List<TaskModel>> watchTasksForTrip({
    required String userId,
    required String tripId,
  }) {
    return _tasks
        .where('userId', isEqualTo: userId)
        .where('tripId', isEqualTo: tripId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(TaskModel.fromFirestore).toList(),
        );
  }

  @override
  Future<TaskModel> createTask({
    required String userId,
    required String tripId,
    required String title,
  }) async {
    final now = DateTime.now();
    final doc = await _tasks.add({
      'userId': userId,
      'tripId': tripId,
      'title': title,
      'isCompleted': false,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });

    final created = TaskModel(
      id: doc.id,
      userId: userId,
      tripId: tripId,
      title: title,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );

    return created;
  }

  @override
  Future<void> setCompleted({
    required String taskId,
    required bool isCompleted,
  }) async {
    await _tasks.doc(taskId).update({
      'isCompleted': isCompleted,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _tasks.doc(taskId).delete();
  }
}

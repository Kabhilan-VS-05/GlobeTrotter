import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

class TaskState {
  final bool isLoading;
  final List<TaskModel> tasks;
  final String? errorMessage;

  const TaskState({
    this.isLoading = false,
    this.tasks = const [],
    this.errorMessage,
  });

  TaskState copyWith({
    bool? isLoading,
    List<TaskModel>? tasks,
    String? errorMessage,
  }) {
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository _repository;
  StreamSubscription<List<TaskModel>>? _sub;

  TaskNotifier(this._repository) : super(const TaskState());

  void watch({required String userId, required String tripId}) {
    _sub?.cancel();
    state = state.copyWith(isLoading: true, errorMessage: null);
    _sub = _repository.watchTasksForTrip(userId: userId, tripId: tripId).listen(
      (tasks) {
        state = state.copyWith(isLoading: false, tasks: tasks);
      },
      onError: (e) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      },
    );
  }

  Future<void> addTask({
    required String userId,
    required String tripId,
    required String title,
  }) async {
    try {
      await _repository.createTask(userId: userId, tripId: tripId, title: title);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> setCompleted({required String taskId, required bool isCompleted}) async {
    try {
      await _repository.setCompleted(taskId: taskId, isCompleted: isCompleted);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _repository.deleteTask(taskId);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return FirestoreTaskRepository();
});

final taskProvider = StateNotifierProvider.family<TaskNotifier, TaskState, String>((ref, tripId) {
  return TaskNotifier(ref.read(taskRepositoryProvider));
});

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../../tasks/presentation/providers/task_provider.dart';

class ItineraryScreen extends ConsumerStatefulWidget {
  final String tripId;

  const ItineraryScreen({super.key, required this.tripId});

  @override
  ConsumerState<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends ConsumerState<ItineraryScreen> {
  final _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated && authState.user != null) {
        ref
            .read(taskProvider(widget.tripId).notifier)
            .watch(userId: authState.user!.id, tripId: widget.tripId);
      }
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _showAddTaskDialog() async {
    _taskController.clear();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'e.g. Book hotel, Pack passport...',
            ),
            onSubmitted: (_) => Navigator.pop(context, true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Add'),
            ),
          ],
        );
      },
    ).then((confirmed) async {
      if (confirmed != true) return;

      final title = _taskController.text.trim();
      if (title.isEmpty) return;

      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated || authState.user == null) return;

      await ref.read(taskProvider(widget.tripId).notifier).addTask(
            userId: authState.user!.id,
            tripId: widget.tripId,
            title: title,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final taskState = ref.watch(taskProvider(widget.tripId));
    final connectivity = ref.watch(connectivityProvider);

    ref.listen<TaskState>(taskProvider(widget.tripId), (prev, next) {
      final message = next.errorMessage;
      if (message != null && message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        ref.read(taskProvider(widget.tripId).notifier).clearError();
      }
    });

    final isOffline = connectivity.maybeWhen(
      data: (results) => results.isEmpty || results.contains(ConnectivityResult.none),
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Tasks'),
      ),
      body: Column(
        children: [
          if (isOffline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.orange.withOpacity(0.15),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('You are offline. Changes will sync when connection returns.'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (!authState.isAuthenticated || authState.user == null) {
                  return const Center(child: Text('Please sign in to manage tasks.'));
                }

                if (taskState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (taskState.tasks.isEmpty) {
                  return const Center(child: Text('No tasks yet. Tap + to add one.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: taskState.tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final task = taskState.tasks[index];
                    return Dismissible(
                      key: ValueKey(task.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                      onDismissed: (_) {
                        ref.read(taskProvider(widget.tripId).notifier).deleteTask(task.id);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CheckboxListTile(
                          value: task.isCompleted,
                          onChanged: (value) {
                            if (value == null) return;
                            ref
                                .read(taskProvider(widget.tripId).notifier)
                                .setCompleted(taskId: task.id, isCompleted: value);
                          },
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

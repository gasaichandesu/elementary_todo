import 'package:elementary_todo/app/tasks/domain/models/task.dart';

abstract interface class TasksRepository {
  Future<List<Task>> getTasks();

  Future<Task> getTaskById(int taskId);

  Future<void> toggleTaskStatus(int taskId);

  Future<void> createOrUpdateTask({
    int? taskId,
    required String title,
    required String description,
  });

  Future<void> deleteTask(int taskId);
}

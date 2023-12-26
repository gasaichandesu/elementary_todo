import 'package:elementary_todo/app/tasks/domain/models/task.dart';
import 'package:elementary_todo/app/tasks/domain/repositories/tasks_repository.dart';
import 'package:injectable/injectable.dart';

var tasks = [
  const Task(
    id: 0,
    title: 'Learn Dart',
    description: 'Learn Dart for a better understanding of Flutter apps',
  ),
  const Task(
    id: 1,
    title: 'Learn Flutter',
    description: 'Learn Flutter for cross-platform development',
  ),
  const Task(
    id: 2,
    title: 'Learn Elementary',
    description:
        'Learn Elementary Flutter package for better MVVM understanding',
    isActive: false,
  ),
];

@LazySingleton(as: TasksRepository)
final class MockTasksRepository implements TasksRepository {
  @override
  Future<List<Task>> getTasks() {
    return Future.value(
      tasks,
    );
  }

  @override
  Future<Task> getTaskById(int taskId) {
    return Future.value(
      tasks.firstWhere((element) => element.id == taskId),
    );
  }

  @override
  Future<void> createOrUpdateTask({
    int? taskId,
    required String title,
    required String description,
  }) async {
    if (taskId == null) {
      final taskId = tasks.lastOrNull?.id ?? 0;
      final task = Task(id: taskId + 1, title: title, description: description);
      tasks.add(task);

      return;
    }

    tasks = tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(
          title: title,
          description: description,
        );
      }

      return task;
    }).toList();
  }

  @override
  Future<void> deleteTask(int taskId) async {
    tasks.removeWhere((element) => element.id == taskId);
  }

  @override
  Future<void> toggleTaskStatus(int taskId) async {
    tasks = tasks.map((e) {
      if (e.id == taskId) {
        return e.copyWith(isActive: !e.isActive);
      }

      return e;
    }).toList();
  }
}

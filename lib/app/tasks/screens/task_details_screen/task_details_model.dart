import 'package:elementary/elementary.dart';
import 'package:elementary_todo/app/tasks/domain/models/task.dart';
import 'package:elementary_todo/app/tasks/domain/repositories/tasks_repository.dart';
import 'package:elementary_todo/app/tasks/service/bloc/tasks_bloc.dart';

class TaskDetailsModel extends ElementaryModel {
  final TasksBloc _tasksBloc;
  final TasksRepository _tasksRepository;

  TasksState get currentState => _tasksBloc.state;

  Stream<TasksState> get tasksStateStream => _tasksBloc.stream;

  TaskDetailsModel(
    this._tasksBloc,
    this._tasksRepository,
  );

  Future<Task> getTaskById(int taskId) {
    return _tasksRepository.getTaskById(taskId);
  }

  void toggleTaskStatus(int taskId) {
    _tasksBloc.add(
      ToggleTaskStateEvent(taskId: taskId),
    );
  }

  void createOrUpdateTask({
    int? taskId,
    required String title,
    required String description,
  }) {
    _tasksBloc.add(
      CreateOrUpdateTaskEvent(
        title: title,
        description: description,
        taskId: taskId,
      ),
    );
  }

  void deleteTask(int taskId) {
    _tasksBloc.add(
      DeleteTaskEvent(taskId: taskId),
    );
  }
}

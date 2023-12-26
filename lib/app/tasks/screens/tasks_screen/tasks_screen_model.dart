import 'package:elementary/elementary.dart';
import 'package:elementary_todo/app/tasks/service/bloc/tasks_bloc.dart';

class TasksScreenModel extends ElementaryModel {
  final TasksBloc _tasksBloc;

  TasksState get currentState => _tasksBloc.state;

  Stream<TasksState> get tasksStateStream => _tasksBloc.stream;

  TasksScreenModel(
    this._tasksBloc,
  );

  @override
  void init() {
    super.init();

    _tasksBloc.add(
      LoadTasksEvent(),
    );
  }

  void onTaskStatusChanged(int taskId) {
    _tasksBloc.add(
      ToggleTaskStateEvent(taskId: taskId),
    );
  }
}

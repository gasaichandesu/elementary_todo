part of 'tasks_bloc.dart';

@immutable
sealed class TasksState {
  const TasksState();
}

final class TasksInitial extends TasksState {}

final class TasksLoaded extends TasksState {
  final List<Task> tasks;

  const TasksLoaded({
    this.tasks = const [],
  });
}

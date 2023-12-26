part of 'tasks_bloc.dart';

@immutable
sealed class TasksEvent {
  const TasksEvent();
}

final class LoadTasksEvent extends TasksEvent {}

final class ToggleTaskStateEvent extends TasksEvent {
  final int taskId;

  const ToggleTaskStateEvent({
    required this.taskId,
  });
}

final class CreateOrUpdateTaskEvent extends TasksEvent {
  final int? taskId;

  final String title;

  final String description;

  const CreateOrUpdateTaskEvent({
    this.taskId,
    required this.title,
    required this.description,
  });
}

final class DeleteTaskEvent extends TasksEvent {
  final int taskId;

  const DeleteTaskEvent({
    required this.taskId,
  });
}

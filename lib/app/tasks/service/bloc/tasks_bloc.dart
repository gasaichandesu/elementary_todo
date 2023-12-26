import 'dart:async';

import 'package:elementary_todo/app/tasks/domain/models/task.dart';
import 'package:elementary_todo/app/tasks/domain/repositories/tasks_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

@lazySingleton
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository tasksRepository;

  TasksBloc({
    required this.tasksRepository,
  }) : super(TasksInitial()) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<LoadTasksEvent>(_onLoadTasksEvent);
    on<ToggleTaskStateEvent>(_onToggleTaskStateEvent);
    on<CreateOrUpdateTaskEvent>(_onCreateOrUpdateTaskEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
  }

  FutureOr<void> _onLoadTasksEvent(
    LoadTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    final tasks = await tasksRepository.getTasks();

    emit(
      TasksLoaded(
        tasks: tasks,
      ),
    );
  }

  FutureOr<void> _onToggleTaskStateEvent(
    ToggleTaskStateEvent event,
    Emitter<TasksState> emit,
  ) async {
    final state = this.state;

    if (state is! TasksLoaded) {
      return;
    }

    await tasksRepository.toggleTaskStatus(event.taskId);

    emit(
      TasksLoaded(
        tasks: await tasksRepository.getTasks(),
      ),
    );
  }

  FutureOr<void> _onCreateOrUpdateTaskEvent(
    CreateOrUpdateTaskEvent event,
    Emitter<TasksState> emit,
  ) async {
    await tasksRepository.createOrUpdateTask(
      title: event.title,
      description: event.description,
      taskId: event.taskId,
    );

    emit(
      TasksLoaded(
        tasks: await tasksRepository.getTasks(),
      ),
    );
  }

  FutureOr<void> _onDeleteTaskEvent(
    DeleteTaskEvent event,
    Emitter<TasksState> emit,
  ) async {
    await tasksRepository.deleteTask(
      event.taskId,
    );

    emit(
      TasksLoaded(
        tasks: await tasksRepository.getTasks(),
      ),
    );
  }
}

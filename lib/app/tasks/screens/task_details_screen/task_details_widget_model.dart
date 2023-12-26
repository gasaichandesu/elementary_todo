import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:elementary_todo/app/di/di_container.dart';
import 'package:elementary_todo/app/tasks/domain/models/task.dart';
import 'package:elementary_todo/app/tasks/domain/repositories/tasks_repository.dart';
import 'package:elementary_todo/app/tasks/screens/task_details_screen/task_details_model.dart';
import 'package:elementary_todo/app/tasks/screens/task_details_screen/task_details_screen.dart';
import 'package:elementary_todo/app/tasks/service/bloc/tasks_bloc.dart';
import 'package:flutter/material.dart';

TaskDetailsWidgetModelImpl taskDetailsWidgetModelFactory(
  BuildContext context, {
  int? taskId,
}) {
  return TaskDetailsWidgetModelImpl(
    TaskDetailsModel(
      locator.get<TasksBloc>(),
      locator.get<TasksRepository>(),
    ),
    taskId: taskId,
  );
}

class TaskDetailsWidgetModelImpl
    extends WidgetModel<TaskDetailsScreen, TaskDetailsModel>
    implements TaskDetailsWidgetModel {
  TaskDetailsWidgetModelImpl(
    super.model, {
    this.taskId,
  });

  final int? taskId;

  late final _isInEditingStateNotifier = StateNotifier<bool>(
    initValue: taskId == null,
  );

  final _taskNotifier = EntityStateNotifier<Task>();

  final _titleEditingController = TextEditingController();

  final _descriptionEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final StreamSubscription<TasksState> _tasksStateSubscription;

  @override
  StateNotifier<bool> get isInEditingState => _isInEditingStateNotifier;

  @override
  EntityStateNotifier<Task> get task => _taskNotifier;

  @override
  void initWidgetModel() async {
    super.initWidgetModel();

    if (_isInEditingStateNotifier.value == false) {
      await _getTask();
    }

    _tasksStateSubscription = model.tasksStateStream.listen((event) {
      _getTask();
    });
  }

  @override
  void onCancel() {
    if (taskId == null) {
      context.popRoute();
      return;
    }

    _isInEditingStateNotifier.accept(false);
    _titleEditingController.text = _taskNotifier.value.data!.title;
    _descriptionEditingController.text = _taskNotifier.value.data!.description;
  }

  @override
  void onEdit() {
    if (_isInEditingStateNotifier.value == true) {
      model.createOrUpdateTask(
        taskId: taskId,
        title: _titleEditingController.text,
        description: _descriptionEditingController.text,
      );

      if (taskId == null) {
        context.popRoute();
      }
    }

    _isInEditingStateNotifier
        .accept(!(_isInEditingStateNotifier.value ?? false));
  }

  @override
  void onToggleTaskStatus() {
    if (_isInEditingStateNotifier.value == true) {
      return;
    }

    model.toggleTaskStatus(
      taskId!,
    );
  }

  Future<void> _getTask() async {
    _taskNotifier.loading();

    final task = await model.getTaskById(taskId!);

    print(task);

    _taskNotifier.content(task);

    _titleEditingController.text = task.title;
    _descriptionEditingController.text = task.description;
  }

  @override
  TextEditingController get descriptionTextController =>
      _descriptionEditingController;

  @override
  TextEditingController get titleTextController => _titleEditingController;

  @override
  void onDelete() {
    model.deleteTask(taskId!);

    context.popRoute();
  }

  @override
  GlobalKey<FormState> get editingFormKey => _formKey;

  @override
  void dispose() {
    _tasksStateSubscription.cancel();
    _taskNotifier.dispose();
    _isInEditingStateNotifier.dispose();

    super.dispose();
  }
}

abstract interface class TaskDetailsWidgetModel implements IWidgetModel {
  StateNotifier<bool> get isInEditingState;

  EntityStateNotifier<Task> get task;

  void onEdit();

  void onCancel();

  void onToggleTaskStatus();

  void onDelete();

  TextEditingController get titleTextController;

  TextEditingController get descriptionTextController;

  GlobalKey<FormState> get editingFormKey;
}

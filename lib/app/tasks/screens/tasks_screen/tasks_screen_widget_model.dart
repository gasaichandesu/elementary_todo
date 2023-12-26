import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:elementary_todo/app/di/di_container.dart';
import 'package:elementary_todo/app/router/app_router.gr.dart';
import 'package:elementary_todo/app/tasks/domain/models/task.dart';
import 'package:elementary_todo/app/tasks/screens/tasks_screen/tasks_screen.dart';
import 'package:elementary_todo/app/tasks/screens/tasks_screen/tasks_screen_model.dart';
import 'package:elementary_todo/app/tasks/service/bloc/tasks_bloc.dart';
import 'package:flutter/material.dart';

const _tabsCount = 2;

const _activeTasksTabIndex = 0;

TasksScreenWidgetModelImpl tasksScreenWidgetModelFactory(
  BuildContext context,
) {
  return TasksScreenWidgetModelImpl(
    TasksScreenModel(
      locator.get<TasksBloc>(),
    ),
  );
}

class TasksScreenWidgetModelImpl
    extends WidgetModel<TasksScreen, TasksScreenModel>
    with SingleTickerProviderWidgetModelMixin
    implements TasksScreenWidgetModel {
  late final TabController _tabController;

  late final StreamSubscription<TasksState> _tasksStateSubscription;

  final _tasksNotifier = EntityStateNotifier<List<Task>>();

  TasksScreenWidgetModelImpl(
    super.model,
  );

  @override
  void initWidgetModel() {
    _tabController = TabController(
      length: _tabsCount,
      vsync: this,
    );

    _tabController.addListener(
      () => _updateState(
        model.currentState,
      ),
    );

    _tasksStateSubscription = model.tasksStateStream.listen(_updateState);
    _updateState(model.currentState);

    super.initWidgetModel();
  }

  @override
  TabController get tabController => _tabController;

  @override
  EntityStateNotifier<List<Task>> get tasks => _tasksNotifier;

  void _updateState(TasksState currentState) {
    switch (currentState) {
      case TasksInitial():
        _tasksNotifier.loading();
      case TasksLoaded():
        final activeTabIsVisible = _tabController.index == _activeTasksTabIndex;
        final content = currentState.tasks
            .where(
              (element) => element.isActive == activeTabIsVisible,
            )
            .toList();

        _tasksNotifier.content(content);
    }
  }

  @override
  void onTaskStatusChanged(
    int taskId,
    bool? value,
  ) {
    model.onTaskStatusChanged(taskId);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task has been moved to ${value == true ? 'Completed' : 'Active'}',
        ),
      ),
    );
  }

  @override
  void onTaskDetails(int? taskId) {
    context.pushRoute(
      TaskDetailsRoute(taskId: taskId),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _tasksStateSubscription.cancel();
    _tasksNotifier.dispose();
  }
}

abstract interface class TasksScreenWidgetModel implements IWidgetModel {
  TabController get tabController;

  EntityStateNotifier<List<Task>> get tasks;

  void onTaskStatusChanged(
    int taskId,
    bool? value,
  );

  void onTaskDetails(int? taskId);
}

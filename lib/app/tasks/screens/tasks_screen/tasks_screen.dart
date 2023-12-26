import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:elementary_todo/app/tasks/screens/tasks_screen/tasks_screen_widget_model.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TasksScreen extends ElementaryWidget<TasksScreenWidgetModel> {
  const TasksScreen({super.key})
      : super(
          tasksScreenWidgetModelFactory,
        );

  @override
  Widget build(TasksScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elementary Todo'),
        bottom: TabBar(
          tabs: const [
            Tab(
              text: 'Active',
            ),
            Tab(
              text: 'Completed',
            ),
          ],
          controller: wm.tabController,
        ),
      ),
      body: EntityStateNotifierBuilder(
        listenableEntityState: wm.tasks,
        loadingBuilder: (context, tasks) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        builder: (context, tasks) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            itemCount: tasks!.length,
            itemBuilder: (context, index) {
              final task = tasks.elementAt(index);

              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                onTap: () => wm.onTaskDetails(task.id),
                leading: Checkbox.adaptive(
                  onChanged: (value) => wm.onTaskStatusChanged(
                    task.id,
                    value,
                  ),
                  value: !task.isActive,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => wm.onTaskDetails(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}

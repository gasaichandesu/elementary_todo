import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:elementary_todo/app/tasks/screens/task_details_screen/task_details_widget_model.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TaskDetailsScreen extends ElementaryWidget<TaskDetailsWidgetModel> {
  final int? taskId;

  TaskDetailsScreen({
    super.key,
    @QueryParam('taskId') this.taskId,
  }) : super(
          (context) => taskDetailsWidgetModelFactory(
            context,
            taskId: taskId,
          ),
        );

  @override
  Widget build(TaskDetailsWidgetModel wm) {
    return StateNotifierBuilder(
      listenableState: wm.isInEditingState,
      builder: (context, isInEditingState) {
        return EntityStateNotifierBuilder(
          listenableEntityState: wm.task,
          builder: (context, task) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Task Details'),
                actions: [
                  IconButton(
                    key: const ValueKey('task_details_edit_button'),
                    onPressed: wm.onEdit,
                    icon: Icon(
                      isInEditingState == true ? Icons.done : Icons.edit,
                    ),
                  ),
                  if (isInEditingState == true)
                    IconButton(
                      key: const ValueKey('task_details_cancel_button'),
                      onPressed: wm.onCancel,
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: FocusScope.of(context).unfocus,
                  child: Column(
                    children: [
                      Form(
                        key: wm.editingFormKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 16.0,
                              ),
                              child: TextFormField(
                                controller: wm.titleTextController,
                                decoration: const InputDecoration(
                                  label: Text('Title'),
                                ),
                                readOnly: isInEditingState == false,
                              ),
                            ),
                            TextFormField(
                              controller: wm.descriptionTextController,
                              decoration: const InputDecoration(
                                label: Text('Description'),
                              ),
                              minLines: 5,
                              maxLines: 10,
                              readOnly: isInEditingState == false,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (isInEditingState == false && taskId != null)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  wm.onToggleTaskStatus();
                                },
                                child: Text(
                                  task?.isActive == true
                                      ? 'Complete'
                                      : 'Activate',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                wm.onDelete();
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_scheduler/bloc/tasks_bloc.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:task_scheduler/views/add_task_popup.dart';
import 'package:task_scheduler/views/task_view.dart';

class TaskSchedulerScreen extends StatelessWidget {
  TaskSchedulerScreen({super.key});

  Future<String?> _editTask(BuildContext context, String initalText) async {
    TextEditingController textController = TextEditingController(text: initalText);
    return showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Edit Tasks'),
              content: TextFormField(controller: textController),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(textController.text);
                    },
                    child: Text('Done'))
              ],
            ));
  }

  //FOR SNACK BAR DO NOT DELETE
  // _showStatus(BuildContext context, TaskProgress status) {
  //   Map<TaskProgress, String> messages = {
  //     TaskProgress.Create: "Successfully created a new Task",
  //     TaskProgress.Edit: "Successfully edited task",
  //     TaskProgress.Done: "Well done completing a task!",
  //   };
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(messages[status]!),
  //     duration: Duration(seconds: 2),
  //     backgroundColor: Colors.green,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TasksBloc>();
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state is TasksInitial) {
          bloc.add(GetTasksFromDataBase());
          return Center(
            child: CircularProgressIndicator(
              color: Colors.pink,
            ),
          );
        } else if (state is TasksLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.pink,
            ),
          );
        } else if (state is NoTasks) {
          // add a cat image here if you want
          return Center(
            child: Text('Wohoo No tasks yet...'),
          );
        } else if (state is TaskError) {
          return Center(
            child: Text('Hmm Something is wrong please try again'),
          );
        } else if (state is TasksLoaded) {
          final tasks = (state as TasksLoaded).task;
          List<String> taskName = [];
          for (var i in tasks) {
            taskName.add(i.content);
          }
          print(taskName);
          return ListView(
            children: tasks.map((e) {
              return TaskView(
                  inReadMode: true,
                  ////////////////
                  task: Task(content: e.content, reminderTime: e.reminderTime),
                  onEditPressed: () async {
                    final updatedTask = await _editTask(context, e.content);
                    if (updatedTask != null) {
                      bloc.add(EditTasks(id: e.id!, updatedTask: updatedTask, updatedReminder: null));
                    }
                  },
                  onDonePressed: () {
                    bloc.add(DoneTask(e.id!));
                  },
                  onUpButtonPressed: () {
                    bloc.add(MoveTask(e.id!, MovementDirection.up));
                  },
                  onDownButtonPressed: () {
                    bloc.add(MoveTask(e.id!, MovementDirection.down));
                  });
            }).toList() as List<Widget>,
          );
        }
        throw Exception("Unhandled State");
      },
    );
  }
}

class TaskSchedulerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Scheduler")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            showDialog(context: context, builder: (context) => AddTaskPopup()),
      ),
      body: TaskSchedulerScreen(),
    );
  }
}

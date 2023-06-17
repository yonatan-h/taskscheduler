import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_scheduler/bloc/tasks_bloc.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:task_scheduler/views/add_task_popup.dart';
import 'package:task_scheduler/views/task_view.dart';

class TaskSchedulerScreen extends StatelessWidget {
  TaskSchedulerScreen({super.key});

  Future<Task?> _editTask(BuildContext context, Task task) async {
    TextEditingController textController = TextEditingController(text:task.content);
    return showDialog<Task>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Edit Task'),
              content: Column(
                children: [
                  TextFormField(
                    controller: textController,
                  ),
                  TextButton(
                      onPressed: () async {
                        var now = DateTime.now();
                        var after30days = now.add(Duration(days: 30));

                        DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: now,
                            lastDate: after30days);
                        if (selectedDate == null) return;

                        TimeOfDay? selectedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (selectedTime == null) return;

                        task.reminderTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute);
                      },
                      child: Text('Set Reminder'))
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      task.content = textController.text;
                      Navigator.of(context).pop(task);
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
        } else if (state is TaskSuccess) {
          return Center(
            child: Text('adding task ...'),
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
                    final updatedTask = await _editTask(context, e);
                    if (updatedTask != null) {
                      bloc.add(EditTasks(
                          id: e.id!,
                          updatedTask: updatedTask.content,
                          updatedReminder: updatedTask.reminderTime));
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
  Future<Task?> _createTask(BuildContext context) async {
    TextEditingController textController = TextEditingController();
    DateTime? reminderTime;
    return showDialog<Task>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Create Task'),
              content: Column(
                children: [
                  TextFormField(controller: textController),
                  TextButton(
                      onPressed: () async {
                        var now = DateTime.now();
                        var after30days = now.add(Duration(days: 30));

                        DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: now,
                            lastDate: after30days);
                        if (selectedDate == null) return;

                        TimeOfDay? selectedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (selectedTime == null) return;

                        reminderTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute);
                      },
                      child: Text('Set Reminder'))
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      var task = Task(
                          content: textController.text,
                          reminderTime: reminderTime);
                      Navigator.of(context).pop(task);
                    },
                    child: Text('Done'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Scheduler")),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final bloc = context.read<TasksBloc>();
            var task = await _createTask(context);
            print('here');
            if (task == null) return;
            bloc.add(CreateNewTask(task));
          }),
      body: TaskSchedulerScreen(),
    );
  }
}

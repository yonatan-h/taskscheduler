import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_scheduler/bloc/tasks_bloc.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:task_scheduler/views/add_task_popup.dart';
import 'package:task_scheduler/views/task_view.dart';

class TaskSchedulerScreen extends StatelessWidget {
  TaskSchedulerScreen({super.key});

  // List<Task> tasks = [
  //   Task(
  //       content: "abebe endezi keza indezi keza indexi keza beka indeza",
  //       reminderTime: DateTime.now()),
  //   Task(content: "abebe", reminderTime: DateTime.now()),
  //   Task(content: "abebe", reminderTime: DateTime.now()),
  //   Task(content: "abebe", reminderTime: DateTime.now()),
  //   Task(content: "abebe", reminderTime: DateTime.now()),
  // ];

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
                    task: Task(content: e.content, reminderTime: e.reminderTime),
                    onEditPressed: () {},
                    onDonePressed: () {},
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

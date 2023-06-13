import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:task_scheduler/views/add_task_popup.dart';
import 'package:task_scheduler/views/task_view.dart';

class TaskSchedulerApp extends StatelessWidget {
  TaskSchedulerApp({super.key});

  List<Task> tasks = [
    Task(
        content: "abebe endezi keza indezi keza indexi keza beka indeza",
        reminderTime: DateTime.now()),
    Task(content: "abebe", reminderTime: DateTime.now()),
    Task(content: "abebe", reminderTime: DateTime.now()),
    Task(content: "abebe", reminderTime: DateTime.now()),
    Task(content: "abebe", reminderTime: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Scheduler")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            showDialog(context: context, builder: (context) => AddTaskPopup()),
      ),
      body: ListView(
        children: tasks.map((e) => TaskView(e)).toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:task_scheduler/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_scheduler/bloc/tasks_bloc.dart';
import 'package:task_scheduler/db.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DataProvider(),
      child: BlocProvider(
        create: (context) =>
            TasksBloc(dataProvider: context.read<DataProvider>()),
        child: MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
              useMaterial3: true,
            ),
            title: "Task Scheduler App",
            home: TaskSchedulerApp()),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:task_scheduler/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_scheduler/bloc/tasks_bloc.dart';
import 'package:task_scheduler/db.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  runApp(TaskApp());
}

void initializeNotifications() {
  String? defaultIcon = null;
  List<NotificationChannel> channels = [
    NotificationChannel(
        channelGroupKey: 'reminders',
        channelKey: 'instant_notification',
        channelName: 'Basic Instant Notification',
        channelDescription: 'I can instant notify you')
  ];
  var awesomeNotifications = AwesomeNotifications();
  awesomeNotifications.initialize(defaultIcon, channels);
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

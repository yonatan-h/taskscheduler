import 'package:flutter/material.dart';
import 'package:task_scheduler/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_scheduler/bloc/tasks_bloc.dart';
import 'package:task_scheduler/data_providers/tasks_db.dart';
import 'package:task_scheduler/data_providers/notifications_db.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  await initializeNotifications();
  runApp(TaskApp());
}

initializeNotifications() async {
  String? defaultIcon = null;
  List<NotificationChannel> channels = [
    NotificationChannel(
        channelGroupKey: 'reminders',
        channelKey: 'channel',
        channelName: 'Task Scheduler Reminders',
        channelDescription:
            'Notifies according to the reminder set for a task.')
  ];
  var awesomeNotifications = AwesomeNotifications();
  await awesomeNotifications.initialize(defaultIcon, channels);
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TasksDataProvider()),
        RepositoryProvider(create: (context) => NotificationsDataProvider()),
      ],
      child: BlocProvider(
        create: (context) => TasksBloc(
            tasksDataProvider: context.read<TasksDataProvider>(),
            notificationsDataProvider:
                context.read<NotificationsDataProvider>()),
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

import 'package:flutter/material.dart';
import 'package:task_scheduler/app.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      title: "Task Scheduler App",
      home: TaskSchedulerApp()));
}

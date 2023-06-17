import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:intl/intl.dart';

class AddTaskPopup extends StatefulWidget {
  AddTaskPopup({super.key});

  @override
  State<AddTaskPopup> createState() => _AddTaskPopupState();
}

class _AddTaskPopupState extends State<AddTaskPopup> {
  final formKey = GlobalKey<FormState>();

  late String content;
  DateTime? reminderTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create Task"),
      content: Form(
        key: formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  TextFormField(
                      decoration: InputDecoration(hintText: "Enter the task"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please write something';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        print('-----------------is saved');
                        content = value as String;
                      }),
                  const SizedBox(height: 20),
                  Text(reminderTime == null
                      ? "No Reminder"
                      : DateFormat('EEEE MMMM d h:m a').format(reminderTime!)),
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

                        setState(() {
                          reminderTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute);
                        });
                      },
                      child: Text('Set Reminder'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DummyReminder(),
                  TextButton(
                      onPressed: () {
                        var isValid = formKey.currentState!.validate();
                        if (isValid) {
                          formKey.currentState!.save();
                          var task = Task(
                              content: content, reminderTime: reminderTime);
                          print(
                              'new Task -> content:${task.content} and reminder:${task.reminderTime}');
                        }
                      },
                      child: Text('Save')),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'))
                ],
              )
            ]),
      ),
    );
  }
}

class DummyReminder extends StatelessWidget {
  const DummyReminder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () async {
              print('3 seconds away');
              var awesomeNotifications = AwesomeNotifications();
              var notificationContent = NotificationContent(
                id: Random().nextInt(100),
                channelKey: "instant_notification",
                title: "Abebe?",
                body: "I am the hello world of every thing!"
                );
              awesomeNotifications.createNotification(content: notificationContent);
            },
            child: Text('3seconds')),
      ],
    );
  }
}

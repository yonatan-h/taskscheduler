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
    return Center(
        child: IntrinsicHeight(
      child: AlertDialog(
        title: Text("Create Task"),
        content: Form(
          key: formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: "Enter the task"),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please write something'
                    : null,
                onSaved: (value) => content = value as String,
              ),
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
        ),
        actions: [
          TextButton(
              onPressed: () async {
                var isValid = formKey.currentState!.validate();
                if (isValid) {
                  formKey.currentState!.save();
                  var task = Task(content: content, reminderTime: reminderTime);

                  print(
                      'new Task -> content:${task.content} and reminder:${task.reminderTime}');
                }
              },
              child: Text('Save')),
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel'))
        ],
      ),
    ));
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
              //
            },
            child: Text('3seconds')),
      ],
    );
  }
}

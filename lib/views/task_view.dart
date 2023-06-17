import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_scheduler/bloc/tasks_bloc.dart';
import 'package:task_scheduler/models/task.dart';

class TaskView extends StatelessWidget {
  Task task;
  VoidCallback onEditPressed;
  VoidCallback onDonePressed;
  VoidCallback onUpButtonPressed;
  VoidCallback onDownButtonPressed;

  bool inReadMode;

  TaskView(
      {
      ////////////
      required this.inReadMode,
      ////////////

      required this.task,
      required this.onEditPressed,
      required this.onDonePressed,
      required this.onUpButtonPressed,
      required this.onDownButtonPressed,
      super.key});

  TextEditingController textController = TextEditingController();

  Widget readMode() {
    return Row(children: [
      //
      Expanded(
        flex: 3,
        child: Column(children: [
          Text(
            task.content,
            softWrap: true,
          ),
          const SizedBox(height: 10),
          Row(children: [
            TextButton(
              child: const Text(
                "Edit",
                textScaleFactor: 0.9,
              ),
              onPressed: onEditPressed
            ),
            TextButton(
              child: const Text(
                "Reminder",
                textScaleFactor: 0.9,
              ),
              onPressed: () => {},
            ),
            TextButton(
              child: const Text(
                "Done!",
                textScaleFactor: 0.9,
              ),
              onPressed: onDonePressed,
            )
          ])
        ]),
      ),

      Expanded(
        flex: 1,
        child: Column(children: [
          IconButton(
              onPressed: onUpButtonPressed,
              icon: const Icon(Icons.arrow_upward)),
          IconButton(
              onPressed: onDownButtonPressed,
              icon: const Icon(Icons.arrow_downward)),
        ]),
      )
    ]);
  }

  Widget writeMode() {
    return Column(children: [
      TextField(
        minLines: 2,
        maxLines: 5,
        controller: textController,
      ),
      Row(
        children: [
          TextButton(
              onPressed: () {
                print(textController.text);
              },
              child: const Text("Save")),
          TextButton(
              onPressed: () {
                // setState(() => inReadMode = true);
              },
              child: const Text("Cancel"))
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: inReadMode ? readMode() : writeMode()));
  }
}

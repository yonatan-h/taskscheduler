import 'package:flutter/material.dart';
import 'package:task_scheduler/models/task.dart';

class TaskView extends StatefulWidget {
  Task task;
  VoidCallback onEditPressed;
  VoidCallback onDonePressed;
  VoidCallback onUpButtonPressed;
  VoidCallback onDownButtonPressed;

  TaskView({
    required this.task,
    required this.onEditPressed,
    required this.onDonePressed,
    required this.onUpButtonPressed,
    required this.onDownButtonPressed,
    super.key
    });

  @override
  State<TaskView> createState() => _TaskViewState(task);
}

class _TaskViewState extends State<TaskView> {
  Task task;
  TextEditingController textController = TextEditingController();

  _TaskViewState(this.task);

  bool inReadMode = true;

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
              onPressed: () {
                setState(() => inReadMode = false);
              },
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
              onPressed: widget.onDonePressed,
            )
          ])
        ]),
      ),

      Expanded(
        flex: 1,
        child: Column(children: [
          IconButton(onPressed: widget.onUpButtonPressed, icon: const Icon(Icons.arrow_upward)),
          IconButton(
              onPressed: widget.onDownButtonPressed, icon: const Icon(Icons.arrow_downward)),
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
                setState(() => inReadMode = true);
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

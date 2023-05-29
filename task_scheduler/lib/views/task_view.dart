import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_scheduler/models/task.dart';

class TaskView extends StatefulWidget {
  Task task;

  TaskView(this.task, {super.key});

  @override
  State<TaskView> createState() => _TaskViewState(task);
}

class _TaskViewState extends State<TaskView> {
  Task task;
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
          SizedBox(height: 10),
          Row(children: [
            TextButton(
              child: Text(
                "Edit",
                textScaleFactor: 0.9,
              ),
              onPressed: () {
                setState(() => inReadMode = false);
              },
            ),
            TextButton(
              child: Text(
                "Reminder",
                textScaleFactor: 0.9,
              ),
              onPressed: () => {},
            ),
            TextButton(
              child: Text(
                "Done!",
                textScaleFactor: 0.9,
              ),
              onPressed: () => {},
            )
          ])
        ]),
      ),

      Expanded(
        flex: 1,
        child: Column(children: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_upward)),
          IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_downward)),
        ]),
      )
    ]);
  }

  Widget writeMode() {
    return Column(children: [
      TextFormField(minLines: 2, maxLines: 5, initialValue: task.content),
      Row(
        children: [
          TextButton(onPressed: () => {}, child: Text("Save")),
          TextButton(
              onPressed: () {
                setState(() => inReadMode = true);
              },
              child: Text("Cancel"))
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: inReadMode ? readMode() : writeMode()));
  }
}

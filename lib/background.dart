import 'package:flutter/material.dart';

class BackgroundCurveWidget extends StatelessWidget {
  const BackgroundCurveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: 200,
            height: 200,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              gradient: LinearGradient(
                  colors: [Colors.pink, Color.fromARGB(120, 250, 133, 172)]),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Task Scheduler',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 20,
        ),
        Container(
            width: 200,
            height: 650,
            margin: EdgeInsets.only(left: 170, top: 30),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100))),
              gradient: LinearGradient(colors: [
                Color.fromARGB(100, 255, 63, 127),
                Color.fromARGB(120, 250, 133, 172)
              ]),
            ),
            child: Container())
      ],
    );
  }
}

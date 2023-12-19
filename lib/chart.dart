import 'package:flutter/material.dart';
import 'package:microhabits/trying/schedule.dart';

class ChartPage extends StatelessWidget {
  final String uid;

  ChartPage({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task Completion Chart'),
        ),
        body: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: TaskCompletionChart(uid: uid),
          ),
        ));
  }
}

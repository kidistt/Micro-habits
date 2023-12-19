import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Task {
  final String category;
  final int count;

  Task(this.category, this.count);
}

class TaskGraph extends StatelessWidget {
  final List<Task> tasks;

  TaskGraph({required this.tasks});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Task, String>> series = [
      charts.Series(
        id: 'Tasks',
        data: tasks,
        domainFn: (Task task, _) => task.category,
        measureFn: (Task task, _) => task.count,
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
      ),
    ];

    return Container(
      height: 200, // Adjust the height as needed
      padding: EdgeInsets.all(16),
      child: charts.BarChart(
        series,
        animate: true,
        vertical: false,
      ),
    );
  }
}

List<Task> tasks = [
  Task('Work', 5),
  Task('Personal', 3),
  Task('Errands', 2),
  Task('Study', 4),
];

class ToDoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('To-Do List App'),
        ),
        body: Column(
          children: [
            // Your other app components here
            TaskGraph(tasks: tasks),
          ],
        ),
      ),
    );
  }
}

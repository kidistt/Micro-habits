import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microhabits/chart.dart';
import 'package:uuid/uuid.dart';

class TODOChart extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    var taskId = uuid.v4();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('To-Do App'),
          backgroundColor: const Color.fromARGB(255, 225, 181, 181),
          actions: [
            IconButton(
              icon: const Icon(Icons.show_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChartPage(uid: uid),
                  ),
                );
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('tasks')
              .where('userId',
                  isEqualTo: uid) // Fetch tasks for the specified user
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final tasks = snapshot.data?.docs;

            return ListView.builder(
              itemCount: tasks?.length,
              itemBuilder: (context, index) {
                final task = tasks![index];

                return ListTile(
                  title: Text(task['name']),
                  leading: Checkbox(
                    activeColor: const Color.fromARGB(255, 225, 181, 181),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    value: task['isComplete'],
                    onChanged: (bool? newValue) async {
                      await task.reference.update({'isComplete': newValue});
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await task.reference.delete();
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final name = await _showAddTaskDialog(context);
            if (name != null) {
              await _firestore.collection('tasks').add({
                'name': name,
                'isComplete': false,
                "id": taskId,
                "userId": uid,
              });
            }
          },
          child: const Icon(Icons.add),
          backgroundColor: const Color.fromARGB(255, 225, 181, 181),
        ),
      ),
    );
  }

  Future<String?> _showAddTaskDialog(BuildContext context) async {
    String? name;

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task',
              style: TextStyle(color: Color.fromARGB(255, 225, 181, 181))),
          content: TextField(onChanged: (String value) => name = value),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 225, 181, 181))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, name),
              child: const Text('OK',
                  style: TextStyle(color: Color.fromARGB(255, 225, 181, 181))),
            ),
          ],
        );
      },
    );

    return name;
  }
}

class TaskCompletionChart extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  TaskCompletionChart({required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('tasks')
          .where('userId', isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data?.docs;
        int completedTasks = 0;
        int uncompletedTasks = 0;

        for (final task in tasks!) {
          if (task['isComplete']) {
            completedTasks++;
          } else {
            uncompletedTasks++;
          }
        }

        final data = [
          TaskCompletionData('Completed', completedTasks),
          TaskCompletionData('Uncompleted', uncompletedTasks),
        ];

        final seriesList = [
          charts.Series<TaskCompletionData, String>(
            id: 'TaskCompletion',
            domainFn: (TaskCompletionData task, _) => task.status,
            measureFn: (TaskCompletionData task, _) => task.count,
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            data: data,
          )
        ];

        return charts.BarChart(
          seriesList,
          animate: true,
        );
      },
    );
  }
}

class TaskCompletionData {
  final String status;
  final int count;

  TaskCompletionData(this.status, this.count);
}

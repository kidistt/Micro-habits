import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StepCountHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Count History'),
      ),
      body: Center(
        child: FutureBuilder<List<charts.Series<StepCountData, String>>>(
          future: _getStepCountData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                width: 200,
                height: 300,
                child: charts.BarChart(
                  snapshot.data!,
                  animate: true,
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<List<charts.Series<StepCountData, String>>> _getStepCountData() async {
    DateTime now = DateTime.now();
    DateTime startOfRange = now.subtract(Duration(days: 30));
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('steps')
        .where('timestamp', isGreaterThanOrEqualTo: startOfRange)
        .get();
    List<StepCountData> data = snapshot.docs.map((doc) {
      return StepCountData(
        steps: doc['steps'],
        timestamp: (doc['timestamp'] as Timestamp).toDate(),
      );
    }).toList();
    return [
      charts.Series<StepCountData, String>(
        id: 'Steps',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (StepCountData data, _) =>
            DateFormat.E().format(data.timestamp),
        measureFn: (StepCountData data, _) => data.steps,
        data: data,
      )
    ];
  }
}

class StepCountData {
  final int steps;
  final DateTime timestamp;

  StepCountData({required this.steps, required this.timestamp});
}

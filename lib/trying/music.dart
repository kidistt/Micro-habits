import 'package:flutter/material.dart';
import 'package:microhabits/trying/pedochart.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pedometer1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedometer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Pedometer Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (await Permission.activityRecognition.request().isGranted) {
      // Permission is granted, you can access the step counter sensor
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(_onData,
          onError: _onError, onDone: _onDone, cancelOnError: true);
    } else {
      // Permission is not granted, handle accordingly
      // ...
    }
  }

  void _onData(StepCount event) {
    setState(() {
      _steps = event.steps - _offset;
    });
  }

  void _onDone() => print('Finished pedometer tracking');

  void _onError(error) => print('Flutter Pedometer Error: $error');

  Future<void> _storeSteps(int steps) async {
    await FirebaseFirestore.instance.collection('steps').add({
      'steps': _steps,
      'timestamp': DateTime.now(),
    });
  }

  Future<void> _resetSteps() async {
    await _storeSteps(_steps);
    setState(() {
      _offset = _offset + _steps;
      _steps = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StepCountHistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Steps taken:',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_steps',
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetSteps,
        tooltip: 'Reset',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

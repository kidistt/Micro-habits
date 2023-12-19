import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microhabits/chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:microhabits/homepage.dart';
import 'package:microhabits/trying/pedochart.dart';
import 'package:microhabits/trying/schedule.dart';
import 'package:uuid/uuid.dart';

class NavaBarRoots extends StatefulWidget {
  const NavaBarRoots({super.key});

  @override
  State<NavaBarRoots> createState() => _NavaBarRootsState();
}

class _NavaBarRootsState extends State<NavaBarRoots> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var uuid = const Uuid();

  int _selectIndex = 0;
  final _screen = [
    //home screen
    const HomePage(),

    // Schedule Screen

    StepCountHistoryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screen[_selectIndex],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF7165D6),
            unselectedItemColor: Colors.black26,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            currentIndex: _selectIndex,
            onTap: (index) {
              setState(() {
                _selectIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.run_circle),
                label: "progress",
              ),
            ]),
      ),
    );
  }
}

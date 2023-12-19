import 'package:flutter/material.dart';
import 'package:microhabits/homepage.dart';
import 'package:microhabits/trying/schedule.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int _selectIndex = 0;
  final screens = [
    HomePage(),
    TODOChart(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Color(0xFF7165D6),
          unselectedItemColor: Colors.black26,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: "Schedule",
            )
          ],
          currentIndex: _selectIndex,
          onTap: (index) {
            setState(() {
              _selectIndex = index;
            });
          }),
    );
  }
}

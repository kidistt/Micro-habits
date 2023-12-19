import 'package:flutter/material.dart';
import 'package:microhabits/Books/firstpage.dart';

class Book extends StatelessWidget {
  const Book({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const FirstPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

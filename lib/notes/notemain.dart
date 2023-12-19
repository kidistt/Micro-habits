import 'package:flutter/material.dart';
import 'package:microhabits/notes/notes.dart';

class NoteMain extends StatelessWidget {
  const NoteMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Notes(),
      debugShowCheckedModeBanner: false,
    );
  }
}

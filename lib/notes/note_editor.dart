import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:microhabits/notes/noteappstyle.dart';

class NoteEditScreen extends StatefulWidget {
  final QueryDocumentSnapshot doc;

  const NoteEditScreen({Key? key, required this.doc}) : super(key: key);

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  String date = DateTime.now().toString();
  late TextEditingController _titleController;
  late TextEditingController _mainController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.doc['note_title']);
    _mainController = TextEditingController(text: widget.doc['note_content']);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Edit Note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Title',
              ),
              style: AppStyle.mainTitle,
            ),
            const SizedBox(height: 8.0),
            Text(date, style: AppStyle.dateTitle),
            const SizedBox(height: 28.0),
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note content',
              ),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: const Color(0xFF7165D6),
        onPressed: () async {
          // Save the updated note to Firestore
          widget.doc.reference.update({
            "note_title": _titleController.text,
            "note_content": _mainController.text,
          }).then((_) {
            Navigator.pop(context);
          }).catchError(
              (error) => print("Failed to update note due to $error"));
        },
        child: const Icon(
          Icons.save,
          size: 25,
        ),
      ),
    );
  }
}

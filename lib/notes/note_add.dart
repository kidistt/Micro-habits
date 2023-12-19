import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:microhabits/notes/noteappstyle.dart';
import 'package:uuid/uuid.dart';

class NoteAddScreen extends StatefulWidget {
  const NoteAddScreen({Key? key}) : super(key: key);

  @override
  State<NoteAddScreen> createState() => _NoteAddScreenState();
}

class _NoteAddScreenState extends State<NoteAddScreen> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  String date = DateTime.now().toString();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var uuid = Uuid();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Add a new note ",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: _mainController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note content',
                ),
                style: AppStyle.mainContent,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Content cannot be null';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: const Color(0xFF7165D6),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // to save out note to fire base
            add();
          }
        },
        child: const Icon(
          Icons.save,
          size: 25,
        ),
      ),
    );
  }

  Future add() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var uuid = const Uuid();
    var taskId = uuid.v4();
    await FirebaseFirestore.instance.collection("Notes").add({
      "note_title": _titleController.text,
      "creation_date": date,
      "note_content": _mainController.text,
      "color_id": color_id,
      "id": taskId,
      "userId": uid,
    }).then((value) {
      print(value.id);
      Navigator.pop(context);
    }).catchError((error) => print("Failed to add new note due to $error"));
  }
}

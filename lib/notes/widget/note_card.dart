import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:microhabits/notes/noteappstyle.dart';
import 'package:uuid/uuid.dart';

import '../note_editor.dart';

Widget noteCard(
    Function()? onTap, QueryDocumentSnapshot doc, BuildContext context) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: AppStyle.cardsColor[doc['color_id']],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc['note_title'],
            style: AppStyle.mainTitle,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            doc['creation_date'],
            style: AppStyle.dateTitle,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  doc.reference.delete();
                },
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteEditScreen(doc: doc),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

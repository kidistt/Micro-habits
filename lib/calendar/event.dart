import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final DateTime date;

  Event({
    required this.id,
    required this.title,
    required this.date,
  });

  factory Event.fromJson(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}

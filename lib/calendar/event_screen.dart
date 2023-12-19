import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:microhabits/calendar/addevent.dart';
import 'package:microhabits/calendar/editevent.dart';
import 'package:microhabits/calendar/event.dart';

//import 'package:flutter/material.dart';
class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade100,
        title: Row(
          children: [
            Text(
              _selectedDate != null
                  ? _selectedDate!.toIso8601String().substring(0, 10)
                  : "All Events",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (_selectedDate != null)
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedDate = null;
                  });
                },
              )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (newDate != null) {
                setState(() {
                  _selectedDate = newDate;
                });
              }
            },
            icon: Icon(
              Icons.calendar_today,
              size: 30,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _selectedDate == null
            ? FirebaseFirestore.instance.collection('events').snapshots()
            : FirebaseFirestore.instance
                .collection('events')
                .where('date',
                    isGreaterThanOrEqualTo: _selectedDate,
                    isLessThan: _selectedDate!.add(Duration(days: 1)))
                .snapshots(),
        builder: (context, snapshot) {
          //handle errors
          if (snapshot.hasError) {
            return Center(
              child: Text("Error fetching data: ${snapshot.error}"),
            );
          }
          //handel loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Event> events =
              snapshot.data!.docs.map((e) => Event.fromJson(e)).toList();

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              Event event = events[index];
              //to delete while swipe
              return Dismissible(
                key: Key(event.title),
                onDismissed: (direction) {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(event.id)
                        .delete();
                  });
                },
                child: ListTile(
                  title: Text(event.title),
                  subtitle: Text(
                      "${event.date.toString().substring(0, 10)} at ${event.date.toString().substring(11, 16)}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEvent(event: event)));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddEvent()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

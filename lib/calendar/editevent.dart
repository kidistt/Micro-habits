import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:microhabits/calendar/event.dart';

class EditEvent extends StatefulWidget {
  final Event event;
  EditEvent({required this.event});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.event.title;
    dateController.text = widget.event.date.toString().substring(0, 10);
    timeController.text = widget.event.date.toString().substring(11, 16);
    _selectedDate = widget.event.date;
    _selectedTime = TimeOfDay.fromDateTime(widget.event.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade100,
        title: Text(
          "Edit Event",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate:
                      _selectedDate != null ? _selectedDate! : DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (newDate != null) {
                  setState(() {
                    _selectedDate = newDate;
                    dateController.text =
                        newDate.toIso8601String().substring(0, 10);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: timeController,
              readOnly: true,
              onTap: () async {
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime:
                      _selectedTime != null ? _selectedTime! : TimeOfDay.now(),
                );
                if (newTime != null) {
                  setState(() {
                    _selectedTime = newTime;
                    timeController.text = newTime.format(context);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedDate != null && _selectedTime != null) {
                  DateTime selectedDateTime = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _selectedTime!.hour,
                    _selectedTime!.minute,
                  );
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(widget.event.id)
                      .update({
                    'title': titleController.text,
                    'date': Timestamp.fromDate(selectedDateTime),
                  });
                  Navigator.pop(context);
                } else {
                  //show datepicker and/or timepicker
                }
              },
              child: Text("Save"),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('events')
                    .doc(widget.event.id)
                    .delete();

                Navigator.pop(context);
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}

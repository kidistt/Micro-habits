import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(Notee());

class Notee extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _textController = TextEditingController();
  final List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple
  ];
  Color _selectedColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Note Taking App'),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('notes').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final notes = snapshot.data?.docs;

                  return ListView.builder(
                    itemCount: notes?.length,
                    itemBuilder: (context, index) {
                      final note = notes![index];

                      return ListTile(
                        title: Text(note['text']),
                        tileColor: Color(note['color']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await note.reference.delete();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration:
                          const InputDecoration(hintText: 'Enter note text'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.color_lens),
                    onPressed: () async {
                      final color = await showDialog<Color>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Select Color'),
                          content: Wrap(
                            children: _colors
                                .map((color) => InkWell(
                                      onTap: () {
                                        Navigator.pop(context, color);
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: color,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      );

                      if (color != null) {
                        _selectedColor = color;
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      final text = _textController.text;
                      if (text.isNotEmpty) {
                        await _firestore.collection('notes').add({
                          'text': text,
                          'color': _selectedColor.value,
                        });
                        _textController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

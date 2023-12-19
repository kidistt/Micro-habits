import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uuid/uuid.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var uuid = Uuid();

  String url = "";
  int? number;
  uploadDataToFirebase() async {
    //generate random number
    number = Random().nextInt(10);

    //pick pdf file
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File pick = File(result.files.single.path.toString());
      var file = pick.readAsBytesSync();
      String name = DateTime.now().microsecondsSinceEpoch.toString();

      // Extract the name of the selected file
      String fileName = result.files.single.name;

      //uploading file to firebase
      var pdfFile = FirebaseStorage.instance.ref().child(name).child("/.pdf");
      UploadTask task = pdfFile.putData(file);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();

      //upload url to cloud firebase

      var taskId = uuid.v4();
      await FirebaseFirestore.instance.collection('books').doc().set({
        'fileUrl': url,
        'fileName': fileName,
        'id': taskId,
        'uid': uid,
      });
    } else {
      // Handle the case where result is null
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "my book shelf",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 225, 181, 181),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('books')
              .where('uid', isEqualTo: uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot x = snapshot.data!.docs[
                      index]; // documnetSnapshot will have all available datas in firebase
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => View(url: x['fileUrl'])));
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(x['fileName']),
                        trailing: SizedBox(
                            width: 100,
                            child: IconButton(
                                onPressed: () {
                                  x.reference.delete();
                                },
                                icon: Icon(Icons.delete))),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 225, 181, 181),
        onPressed: uploadDataToFirebase,
        child: Icon(Icons.add),
      ),
    );
  }
}

class View extends StatelessWidget {
  final url;
  const View({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    PdfViewerController? pdfViewerController;
    return Scaffold(
      appBar: AppBar(
        title: Text("pdf view"),
      ),
      body: SfPdfViewer.network(
        url,
        controller: pdfViewerController,
      ),
    );
  }
}

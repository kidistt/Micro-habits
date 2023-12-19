import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:microhabits/authentication/services/authservice.dart';
import 'package:microhabits/todos/models/taskmodel.dart';
import 'package:uuid/uuid.dart';

class TodoController extends GetxController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var uuid = Uuid();

  var isLoading = false;

  var taskList = <TaskModel>[];

  Future<void> addTodo(String task, bool done, String id) async {
    var taskId = uuid.v4();

    await FirebaseFirestore.instance.collection('todos').doc().set(
      {
        'task': task,
        'isDone': done,
        "id": taskId,
        "userId": uid,
      },
      SetOptions(merge: true),
    ).then((value) => getData());
  }

  Future<void> checkbox(
    String id,
    bool done,
  ) async {
    var taskId = uuid.v4();
    await FirebaseFirestore.instance
        .collection('todos')
        .doc(id)
        .update({'isDone': done});
  }

  Future<void> getData() async {
    try {
      QuerySnapshot taskSnap = await FirebaseFirestore.instance
          .collection('todos')
          .orderBy('task')
          .get();
      var docs = taskSnap.docs;
      taskList.clear();

      for (var item in docs) {
        if (item["userId"] == uid) {
          taskList.add(
            TaskModel(item.id, item['task'], item['isDone']),
          );
        } else {
          print("not working");
        }

        isLoading = false;
        update();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteTask(String id) {
    FirebaseFirestore.instance.collection('todos').doc(id).delete();
  }
}

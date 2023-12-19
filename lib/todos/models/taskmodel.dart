import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  final String task;
  final bool isDone;

  TaskModel(this.id, this.task, this.isDone);

  
  
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todo_controller.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController taskController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: TodoController(),
        initState: (_) {},
        builder: (todoController) {
          todoController.getData();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'My Todos',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Color.fromARGB(255, 225, 181, 181),
            ),
            body: Center(
                child: todoController.isLoading
                    ? SizedBox(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: todoController.taskList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                                leading: Checkbox(
                                    activeColor:
                                        Color.fromARGB(255, 225, 181, 181),
                                    checkColor: Colors.black,
                                    onChanged: (value) =>
                                        todoController.checkbox(
                                          todoController.taskList[index].id,
                                          value!,
                                        ),
                                    value:
                                        todoController.taskList[index].isDone),
                                title: Text(
                                  todoController.taskList[index].task,
                                  style: TextStyle(
                                      decoration:
                                          todoController.taskList[index].isDone
                                              ? TextDecoration.lineThrough
                                              : null),
                                ),
                                trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () => addTaskDialog(
                                                todoController,
                                                'update Task',
                                                todoController
                                                    .taskList[index].id,
                                                todoController
                                                    .taskList[index].task),
                                            icon: Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () => todoController
                                                .deleteTask(todoController
                                                    .taskList[index].id),
                                            icon: Icon(Icons.delete,
                                                color: Colors.red))
                                      ],
                                    ))),
                          );
                        })),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 225, 181, 181),
              child: Icon(
                Icons.add,
              ),
              onPressed: () async =>
                  await addTaskDialog(todoController, 'add todo', '', ''),
            ),
          );
        });
  }

  addTaskDialog(TodoController todoController, String title, String id,
      String task) async {
    if (task.isNotEmpty) {
      taskController.text = task;
    }
    Get.defaultDialog(
      backgroundColor: const Color.fromARGB(255, 225, 181, 181),
      title: 'Add Todo',
      content: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: taskController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'cannot be empty';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await todoController.addTodo(
                    taskController.text.trim(), false, id);
                taskController.clear();
                Get.back();
              },
              child: Text(
                'save',
              ),
            )
          ])),
    );
  }
}

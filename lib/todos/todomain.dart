import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:microhabits/todos/widgets/cbinding.dart';
import 'package:microhabits/todos/screens/todopage.dart';
class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme:ThemeData(
        primarySwatch:Colors.purple,
       

      ),
      home:TodoPage(),
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBindings(),
      
    );
  }
}
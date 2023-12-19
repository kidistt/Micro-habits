import 'package:flutter/material.dart';
import 'package:microhabits/authentication/pages/login.dart';

import 'dart:ui' as ui;

import 'package:microhabits/navbarroot.dart';
import 'package:microhabits/pomodoro/homepage.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavaBarRoots(),
                    ));
              },
              child: const Text("SKIP"),
            ),
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('images/productive.jpg'),
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            "make your day a great day!",
            style: TextStyle(
              letterSpacing: 1,
              wordSpacing: 2,
              fontSize: 20,
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(0, 20),
                  const Offset(100, 20),
                  <Color>[
                    Colors.red,
                    const Color.fromARGB(255, 53, 50, 27),
                  ],
                ),
            ),
          ),
          const SizedBox(height: 60),
          Text(
            'you are stronger than your execuses.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 38, 31, 11)),
          )
        ],
      ),
    ));
  }
}

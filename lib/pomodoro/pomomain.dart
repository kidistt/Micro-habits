import 'package:flutter/material.dart';
import 'package:microhabits/pomodoro/homepage.dart';

class Pomodoro extends StatelessWidget {
  const Pomodoro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) {
          final mediaQueryData = MediaQuery.of(context);
          final screenWidth = 250.0;
          final screenHeight = 400.0;
          return MediaQuery(
            data: mediaQueryData.copyWith(
              size: Size(screenWidth, screenHeight),
              devicePixelRatio: mediaQueryData.devicePixelRatio,
            ),
            child: Container(
              width: screenWidth,
              height: screenHeight,
              child: HomePage(),
            ),
          );
        },
      ),
    );
  }
}

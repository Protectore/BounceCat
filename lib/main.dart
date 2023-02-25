import 'package:bounce_cat/flying_cat.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(canvasColor: Colors.deepPurple),
      home: const Scaffold(
        body: FlyingCat(),
      ),
    );
  }
}

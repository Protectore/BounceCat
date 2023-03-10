import 'package:audioplayers/audioplayers.dart';
import 'package:bounce_cat/bouncing_image.dart';
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
      home: Scaffold(
        body: BouncingImage(
            bounceSound: AudioPlayer()
              ..setSourceAsset("sounds/cat-meow.mp3")
              ..setReleaseMode(ReleaseMode.stop),
            image: Image.asset(
              'assets/images/cat.png',
              width: 200,
              height: 200,
            )),
      ),
    );
  }
}

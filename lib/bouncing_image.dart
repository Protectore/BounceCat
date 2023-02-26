import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BouncingImage extends StatefulWidget {
  final Image image;
  final AudioPlayer? bounceSound;
  final AudioPlayer swipeReleaseSound = AudioPlayer()
    ..setSourceAsset("sounds/swoosh.mp3")
    ..setReleaseMode(ReleaseMode.stop);

  final double gravity = 98;
  final double friction = 2;
  final double elasticity = 0.7;
  final double movementThreshold = 0.005;

  BouncingImage({super.key, required this.image, this.bounceSound});

  @override
  State<BouncingImage> createState() => _BouncingImageState();
}

class _BouncingImageState extends State<BouncingImage> {
  GlobalKey key = GlobalKey();

  Timer? _timer;
  final _timerInterval = const Duration(milliseconds: 10);

  Size? _size;
  double _bottom = 0;
  double _left = 0;

  Offset? _velocity;

  void update() {
    setState(
      () {
        if (_velocity == null) {
          return;
        }

        _size = key.currentContext!.size!;

        var bottom = _bottom;
        var left = _left;
        moveImage();
        var offset = Offset(_left - left, _bottom - bottom);
        updateVelocity();

        if (offset.distance <= widget.movementThreshold) {
          _velocity = null;
        }
      },
    );
  }

  void moveImage() {
    _bottom = clampDouble(
        _bottom - (!_velocity!.dy.isNaN ? _velocity!.dy / 1000 : 0),
        0,
        MediaQuery.of(context).size.height - _size!.height);
    _left = clampDouble(
        _left + (!_velocity!.dx.isNaN ? _velocity!.dx / 1000 : 0),
        0,
        MediaQuery.of(context).size.width - _size!.width);
  }

  void updateVelocity() {
    if (bounce()) {
      debugPrint("bounce");
      widget.bounceSound?.resume();
    }

    _velocity = _velocity!
        .translate(-widget.friction * _velocity!.dx.sign, widget.gravity);
  }

  bool bounce() {
    bool isBounced = false;
    if (_bottom <= 0 ||
        _bottom >= MediaQuery.of(context).size.height - _size!.height) {
      _velocity = _velocity!.scale(1, -widget.elasticity);
      isBounced = true;
    }

    if (_left <= 0 ||
        _left >= MediaQuery.of(context).size.width - _size!.width) {
      _velocity = _velocity!.scale(-widget.elasticity, 1);
      isBounced = true;
    }

    return isBounced;
  }

  void onPanStart(DragStartDetails details) {
    _velocity = null;
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(
      () {
        _bottom -= details.delta.dy;
        _left += details.delta.dx;
      },
    );
  }

  void onPanEnd(DragEndDetails details) {
    _velocity = details.velocity.pixelsPerSecond;
    widget.swipeReleaseSound.resume();
  }

  @override
  void initState() {
    _timer = Timer.periodic(
      _timerInterval,
      (timer) => update(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Stack(
        children: [
          Positioned(
            key: key,
            bottom: _bottom,
            left: _left,
            child: widget.image,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

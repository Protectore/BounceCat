import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BouncingImage extends StatefulWidget {
  late final Image _image;

  final double _gravity = 98;
  final double _friction = -5;

  BouncingImage({super.key, required Image image}) {
    _image = image;
  }

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

        moveImage();
        updateVelocity();
      },
    );
  }

  void moveImage() {
    _size = key.currentContext!.size!;

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
    _velocity = _velocity!.translate(
        widget._friction * _velocity!.dx / _velocity!.dx.abs(),
        widget._gravity);
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
            child: widget._image,
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

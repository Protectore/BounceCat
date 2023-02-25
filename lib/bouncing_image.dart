import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BouncingImage extends StatefulWidget {
  late final Image _image;

  BouncingImage({super.key, required Image image}) {
    _image = image;
  }

  @override
  State<BouncingImage> createState() => _BouncingImageState();
}

class _BouncingImageState extends State<BouncingImage> {
  Timer? _timer;
  final _timerInterval = const Duration(milliseconds: 10);

  final double _gravity = 98;
  final double _friction = -5;

  double _bottom = 0;
  double _left = 0;

  Offset? _velocity;

  @override
  void initState() {
    _timer = Timer.periodic(
      _timerInterval,
      (timer) => update(),
    );

    super.initState();
  }

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
    _bottom = clampDouble(
        _bottom - (!_velocity!.dy.isNaN ? _velocity!.dy / 1000 : 0),
        0,
        MediaQuery.of(context).size.height);
    _left = clampDouble(
        _left + (!_velocity!.dx.isNaN ? _velocity!.dx / 1000 : 0),
        0,
        MediaQuery.of(context).size.width);
  }

  void updateVelocity() {
    _velocity = _velocity!
        .translate(_friction * _velocity!.dx / _velocity!.dx.abs(), _gravity);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _velocity = null;
      },
      onPanUpdate: (details) {
        setState(
          () {
            _bottom -= details.delta.dy;
            _left += details.delta.dx;
          },
        );
      },
      onPanEnd: (details) {
        _velocity = details.velocity.pixelsPerSecond;
      },
      child: Stack(
        children: [
          Positioned(
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

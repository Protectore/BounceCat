import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlyingCat extends StatefulWidget {
  const FlyingCat({super.key});

  @override
  State<FlyingCat> createState() => _FlyingCatState();
}

class _FlyingCatState extends State<FlyingCat> {
  Timer? _timer;

  double _bottom = 0;
  double _left = 0;

  final double _gravity = 98;
  final double _friction = -5;

  Offset? _velocity;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (Timer t) => setState(
        () {
          if (_velocity == null) {
            return;
          }

          _bottom = clampDouble(_bottom - _velocity!.dy / 1000, 0,
              MediaQuery.of(context).size.height);
          _left = clampDouble(_left + _velocity!.dx / 1000, 0,
              MediaQuery.of(context).size.width);

          _velocity = _velocity!.translate(
              _friction * _velocity!.dx / _velocity!.dx.abs(), _gravity);

          debugPrint('$_bottom');
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        onPanStart: (details) {
          _velocity = null;
        },
        onPanUpdate: (details) {
          // debugPrint("${details.delta}");
          setState(
            () {
              _bottom -= details.delta.dy;
              _left += details.delta.dx;
            },
          );
        },
        onPanEnd: (details) {
          // debugPrint('${details.velocity.pixelsPerSecond}');
          _velocity = details.velocity.pixelsPerSecond;
        },
        child: Stack(
          children: [
            Positioned(
              bottom: _bottom,
              left: _left,
              child: Image.asset('assets/images/test.png'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

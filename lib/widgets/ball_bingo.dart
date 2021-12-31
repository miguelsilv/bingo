import 'package:flutter/material.dart';

class BallBingoWidget extends StatelessWidget {
  final int value;
  final double size;
  Color color;

  BallBingoWidget({
    required this.value,
    required this.size,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBall(
      color: color,
      size: size,
      child: _buildBall(
        color: color,
        size: size * 0.7,
        border: Border.all(
          color: Colors.white,
          width: size / 88,
        ),
        child: _buildBall(
            color: Colors.white,
            size: size * 0.6,
            child: Text(
              "$value",
              style: TextStyle(
                color: Colors.black,
                fontSize: size / 3,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }

  Container _buildBall({
    required Widget child,
    required double size,
    Color? color,
    BoxBorder? border,
  }) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: border,
      ),
      child: Center(child: child),
    );
  }
}

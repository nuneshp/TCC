import 'package:flutter/material.dart';

class CustomImageClipper extends CustomClipper<Rect> {
  final double topFactor;
  final double leftFactor;
  final double rightFactor;
  final double bottomFactor;

  CustomImageClipper({
    this.topFactor = 0.0,
    this.leftFactor = 0.0,
    this.rightFactor = 0.0,
    this.bottomFactor = 0.0,
  });

  @override
  Rect getClip(Size size) {
    double top = topFactor * size.height;
    double left = leftFactor * size.width;
    double right = (1.0 - rightFactor) * size.width;
    double bottom = (1.0 - bottomFactor) * size.height;

    return Rect.fromLTRB(left, top, right, bottom);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
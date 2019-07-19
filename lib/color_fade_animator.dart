import 'package:flutter/material.dart';

class ColorFadeAnimator extends Tween<Color> {
  ColorFadeAnimator({Color begin, Color end}) : super(begin: begin, end: end);

  Color lerp(double t) {
    return Color.lerp(begin, end, t);
  }
}

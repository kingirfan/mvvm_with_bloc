import 'package:flutter/material.dart';

Map<int, Color> _swatchOpacity = {
  50: const Color.fromRGBO(139, 195, 74, .1),
  50: const Color.fromRGBO(139, 195, 74, .2),
  50: const Color.fromRGBO(139, 195, 74, .3),
  50: const Color.fromRGBO(139, 195, 74, .4),
  50: const Color.fromRGBO(139, 195, 74, .5),
  50: const Color.fromRGBO(139, 195, 74, .6),
  50: const Color.fromRGBO(139, 195, 74, .7),
  50: const Color.fromRGBO(139, 195, 74, .8),
  50: const Color.fromRGBO(139, 195, 74, .9),
  50: const Color.fromRGBO(139, 195, 74, 1),
};

abstract class CustomColors {
  static Color customContrastColor = Colors.red.shade700;
  static MaterialColor customSwatchColor =
      MaterialColor(0xFF8BC34A, _swatchOpacity);
}

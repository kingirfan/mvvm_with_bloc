import 'package:flutter/material.dart';

import '../../core/theme/custom_colors.dart';

class AppNameWidget extends StatelessWidget {
  final Color? greenColorTitle;
  final double textSize;

  const AppNameWidget({super.key, this.greenColorTitle, this.textSize = 30});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: textSize),
        children: [
          TextSpan(
            text: 'Green',
            style: TextStyle(
              color: greenColorTitle ?? CustomColors.customSwatchColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'grocer',
            style: TextStyle(
              color: CustomColors.customContrastColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

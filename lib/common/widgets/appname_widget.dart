import 'package:flutter/material.dart';

import '../../core/theme/custom_colors.dart';

class AppNameWidget extends StatelessWidget {
  final Color? greenColorTitle;

  const AppNameWidget({super.key, this.greenColorTitle});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'Green',
            style: TextStyle(color: greenColorTitle ?? Colors.green),
          ),
          const TextSpan(
            text: 'grocer',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

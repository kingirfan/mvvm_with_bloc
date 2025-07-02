import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void showSnackbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Size get screenSize => MediaQuery.of(this).size;
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

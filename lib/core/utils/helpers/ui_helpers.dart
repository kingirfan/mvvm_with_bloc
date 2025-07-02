import 'package:flutter/material.dart';
import '../exceptions/app_exception.dart';

void showAppError(BuildContext context, Object error) {
  final message = (error is AppException)
      ? error.message
      : "❌ Unexpected error occurred.";

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

import 'package:flutter/material.dart';

class SnackBarCmp {
  static void show({
    required String message,
    required BuildContext context,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primary,
        duration: duration,
      ),
    );
  }
}

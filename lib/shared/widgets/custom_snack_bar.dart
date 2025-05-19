import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(
    BuildContext context,
    String message, {
    bool fail = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    final color = fail ? Colors.red : Colors.green;
    final icon = fail ? Icons.close : Icons.check;

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: color,
      duration: duration,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

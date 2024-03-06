import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageHandler {
  static void showMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Center(child: Text(message)),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

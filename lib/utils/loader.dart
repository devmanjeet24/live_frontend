import 'package:flutter/material.dart';

class Loader {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFE98834)),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
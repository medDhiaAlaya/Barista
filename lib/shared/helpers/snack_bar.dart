import 'package:flutter/material.dart';

ScaffoldFeatureController snackBar(
    BuildContext context, String text, bool isError) {
  final Color color = isError ? Colors.red.shade300 : Colors.green.shade300;
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: color,
    duration: const Duration(seconds: 1),
  ));
}

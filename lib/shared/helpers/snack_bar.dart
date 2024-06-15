import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String text, bool isError) {
  final Color color = isError ? Colors.red.shade300 : Colors.green.shade300;
  Fluttertoast.showToast(msg: text, backgroundColor: color);
}

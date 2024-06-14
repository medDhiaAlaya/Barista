import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/components/my_button.dart';
import 'package:flutter/material.dart';

Widget errorWidget(String error, Function() onTap) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DefaultText(text: error),
        MyButton(title: 'Refresh', onPressed: onTap)
      ],
    ),
  );
}

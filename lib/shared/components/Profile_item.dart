import 'package:flutter/material.dart';
import 'default_text.dart';

typedef MyFunc = void Function()?;

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onProssed,
    this.color = Colors.black,
  });
  final IconData icon;
  final String title;
  final MyFunc onProssed;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onProssed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        height: 40,
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(
              width: 15,
            ),
            DefaultText(text: title, textSize: 15, textColor: color),
          ],
        ),
      ),
    );
  }
}

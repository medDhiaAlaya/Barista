import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultText extends StatelessWidget {
  const DefaultText({
    super.key,
    required this.text,
    this.textSize = 12,
    this.textColor = const Color(0xFF000714),
    this.weight,
    this.textAlign,
  });
  final String text;
  final double textSize;
  final Color textColor;
  final FontWeight? weight;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.kanit(
        height: 1.2,
        fontWeight: weight,
        color: textColor,
        fontSize: textSize,
      ),
    );
  }
}

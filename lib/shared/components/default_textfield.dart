import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../styles/colors.dart';

typedef MyFunc = void Function()?;

class DefaultTextField extends StatelessWidget {
  const DefaultTextField({
    super.key,
    this.enabled,
    this.onTap,
    required this.hint,
    required this.controller,
    required this.validator,
    required this.textInputType,

    //required this.controller,
  });
  final String hint;
  final TextInputType textInputType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? enabled;
  final MyFunc? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      keyboardType: textInputType,
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 12.0,
        ), // Adjust the padding

        focusColor: kPrimaryColor,
        hintText: hint,
        hintStyle: GoogleFonts.kanit(fontSize: 12),
        border: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

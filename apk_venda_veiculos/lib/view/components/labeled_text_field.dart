import 'package:apk_venda_veiculos/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final int maxLines;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;

  const LabeledTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(color: Colors.white),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: AppTheme.inputLabelColor),
        filled: true,
        fillColor: AppTheme.inputFillColor.withAlpha(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        suffixIcon: suffixIcon,
        errorStyle: GoogleFonts.poppins(color: Colors.red[300]),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

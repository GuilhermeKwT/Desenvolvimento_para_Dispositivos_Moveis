import 'package:apk_venda_veiculos/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value != null && value!.isNotEmpty ? value : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: AppTheme.inputLabelColor),
        filled: true,
        fillColor: AppTheme.inputFillColor.withAlpha(15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium)),
      ),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: GoogleFonts.poppins(color: AppTheme.textPrimary)),
              ))
          .toList(),
      onChanged: onChanged,
      style: GoogleFonts.poppins(color: AppTheme.textPrimary),
      dropdownColor: AppTheme.dropdownColor,
    );
  }
}

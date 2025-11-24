import 'package:flutter/services.dart';

class RenavamMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.isEmpty) {
      return TextEditingValue.empty;
    }

    final limitedText = text.length > 11 ? text.substring(0, 11) : text;

    if (limitedText.length <= 10) {
      return TextEditingValue(
        text: limitedText,
        selection: TextSelection.collapsed(offset: limitedText.length),
      );
    } else {
      final formatted =
          '${limitedText.substring(0, 10)}-${limitedText.substring(10)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final transformed = newValue.text.toUpperCase();
    final selectionIndex = newValue.selection.end;
    final safeIndex = selectionIndex <= transformed.length
        ? selectionIndex
        : transformed.length;
    return TextEditingValue(
      text: transformed,
      selection: TextSelection.collapsed(offset: safeIndex),
    );
  }
}

class PlateMaskFormatter extends TextInputFormatter {
  String currentMask = 'AAA-####';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final raw = text.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');

    String desiredMask = 'AAA-####';
    if (raw.length >= 5 && RegExp(r'[A-Za-z]').hasMatch(raw[4])) {
      desiredMask = 'AAA#A###';
    }

    currentMask = desiredMask;

    if (raw.isEmpty) {
      return TextEditingValue.empty;
    }

    StringBuffer formatted = StringBuffer();
    int rawIndex = 0;

    for (int i = 0; i < desiredMask.length && rawIndex < raw.length; i++) {
      final maskChar = desiredMask[i];

      if (maskChar == '-') {
        formatted.write('-');
      } else if (maskChar == 'A' || maskChar == '#') {
        formatted.write(raw[rawIndex]);
        rawIndex++;
      }
    }

    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class PhoneMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) {
      return TextEditingValue.empty;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 0) {
        buffer.write('(');
      } else if (i == 2) {
        buffer.write(') ');
      } else if (i == 7) {
        buffer.write('-');
      }

      buffer.write(text[i]);

      if (i == 10) {
        break;
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

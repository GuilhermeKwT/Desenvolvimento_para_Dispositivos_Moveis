class AppValidators {
  static String? validateRenavam(String? value) {
    if (value == null || value.isEmpty) {
      return 'Renavam é obrigatório';
    }

    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanValue.length != 11) {
      return 'Renavam deve ter 11 dígitos';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  static String? validatePlate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final cleanValue = value.replaceAll(RegExp(r'[\s\-]'), '').toUpperCase();

    final standardPattern = RegExp(r'^[A-Z]{3}[0-9]{4}$');
    
    final mercosulPattern = RegExp(r'^[A-Z]{3}[0-9]{1}[A-Z]{1}[0-9]{2}$');

    if (standardPattern.hasMatch(cleanValue) || mercosulPattern.hasMatch(cleanValue)) {
      return null;
    }

    return 'Placa deve ter formato AAA-#### ou AAA#A##';
  }
}
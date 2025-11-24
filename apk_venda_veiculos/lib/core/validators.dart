class AppValidators {
  static String? validateRenavam(String? value) {
    if (value == null || value.isEmpty) {
      return null;
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

    if (standardPattern.hasMatch(cleanValue) ||
        mercosulPattern.hasMatch(cleanValue)) {
      return null;
    }

    return 'Placa deve ter formato AAA-#### ou AAA#A##';
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email é obrigatório';
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegex.hasMatch(value)) return 'Email inválido';
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nome é obrigatório';
    if (value.length < 3) return 'Nome deve ter ao menos 3 caracteres';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Telefone é obrigatório';
    final phoneRegex = RegExp(r'^\(\d{2}\)\s?\d{4,5}-\d{4}$');
    if (!phoneRegex.hasMatch(value)) return 'Telefone inválido. Formato: (XX) XXXXX-XXXX';
    return null;
  }
}

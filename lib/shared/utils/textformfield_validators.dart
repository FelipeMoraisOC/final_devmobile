import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextFormFieldValidators {
  String? validatePhone(String? value) {
    final pattern = RegExp(r'^\(\d{2}\) \d{5}-\d{4}$');
    if (value == null || value.isEmpty) {
      return 'Informe o telefone';
    } else if (!pattern.hasMatch(value)) {
      return 'Formato: (99) 99999-9999';
    }
    return null;
  }

  final phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  String? validateEmail(String? value) {
    final pattern = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (value == null || value.isEmpty) {
      return 'Informe o email';
    } else if (!pattern.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a senha';
    } else if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
}

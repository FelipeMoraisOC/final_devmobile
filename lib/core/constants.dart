import 'package:flutter/material.dart';

class AppThemeConstants {
  static const Color primary = Colors.blueAccent;
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkText = Color(0xFF333333);
  static const Color background = Color.fromARGB(255, 255, 255, 255);
  static const Color error = Color(0xFFE57373); // Vermelho suave
  static const Color success = Color(0xFF388E3C); // Verde escuro padrão
  static const Color buttonLight = primary; // Verde médio e limpo
  static const Color buttonDark = primary;
  //Cores de fundo
  static const Color backgroundLight = Color.fromARGB(255, 228, 234, 239);
  static const Color backgroundDark = Color(0xFF212121); // Preto acinzentado
  // Cores de texto
  static const Color textLight = Color(0xFF1B1B1B);
  static const Color textDark = Color(0xFFE0E0E0); //
  // Sombra e bordas
  static const Color shadow = Color(0x33000000); // Sombra sutil
  static const Color border = primary;

  static const Color cardDark = Color(0xFF303030);
  static const Color cardLight = Color.fromARGB(255, 255, 255, 255);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppThemeConstants.darkText,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

class AppStrings {
  static const String loginTitle = 'Login';
  static const String emailHint = 'E-mail';
  static const String passwordHint = 'Senha';
  static const String loginButton = 'Entrar';
  static const String registerButton = 'Registrar-se';
  static const String forgotPasswordButton = 'Esqueci minha senha';
}

import 'package:final_devmobile/core/constants.dart';
import 'package:final_devmobile/core/themes/dark_theme.dart';
import 'package:final_devmobile/core/themes/light_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  final Color _customPrimaryColor = AppThemeConstants.primary;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  Color get primaryColor => _customPrimaryColor;
  Color get scaffoldBackgroundColor =>
      Color.lerp(_customPrimaryColor, Colors.white, 0.96)!;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData get lightTheme => LightTheme.lightTheme;
  ThemeData get darkTheme => DarkTheme.darkTheme;
}

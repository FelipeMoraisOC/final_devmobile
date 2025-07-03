import 'package:final_devmobile/core/constants.dart';
import 'package:final_devmobile/core/themes/dark_theme.dart';
import 'package:final_devmobile/core/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _saveThemeToPrefs();
    notifyListeners();
  }

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  ThemeData get lightTheme => LightTheme.lightTheme;
  ThemeData get darkTheme => DarkTheme.darkTheme;

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode');
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }
}

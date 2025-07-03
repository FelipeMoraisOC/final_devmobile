import 'package:final_devmobile/core/constants.dart';
import 'package:final_devmobile/core/themes/theme_data.dart';
import 'package:flutter/material.dart';

class LightTheme {
  static final ThemeData lightTheme = ThemeData(
    pageTransitionsTheme: myPageTransitions,
    colorScheme: ColorScheme.light(
      primary: AppThemeConstants.primary,
      surface: AppThemeConstants.backgroundLight,
      onPrimary: Colors.white,
    ),
    scaffoldBackgroundColor: AppThemeConstants.backgroundLight,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppThemeConstants.textLight),
      bodyMedium: TextStyle(color: AppThemeConstants.textLight),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppThemeConstants.primary,
      iconTheme: IconThemeData(color: AppThemeConstants.textDark),
      titleTextStyle: TextStyle(
        color: AppThemeConstants.textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(color: AppThemeConstants.textDark),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemeConstants.buttonLight,
        foregroundColor: AppThemeConstants.textDark,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: AppThemeConstants.backgroundDark,
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppThemeConstants.cardLight,
      labelStyle: TextStyle(color: AppThemeConstants.textLight),
      floatingLabelStyle: TextStyle(color: AppThemeConstants.textLight),
      hintStyle: TextStyle(color: AppThemeConstants.textLight),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor:
          AppThemeConstants
              .backgroundDark, // Cor do cursor// Cor do "pino" de seleção
    ),
  );
}

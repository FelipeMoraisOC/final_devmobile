import 'package:final_devmobile/core/constants.dart';
import 'package:flutter/material.dart';

class DarkTheme {
  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: AppThemeConstants.primary,
      surface: AppThemeConstants.backgroundDark,
      onPrimary: Colors.white,
    ),
    scaffoldBackgroundColor: AppThemeConstants.backgroundDark,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppThemeConstants.textDark),
      bodyMedium: TextStyle(color: AppThemeConstants.textDark),
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemeConstants.buttonDark,
        foregroundColor: AppThemeConstants.textDark,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(color: AppThemeConstants.textDark),
    ),

    cardTheme: CardTheme(
      color: AppThemeConstants.cardDark,
      shadowColor: AppThemeConstants.backgroundDark,
      elevation: 4,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppThemeConstants.cardDark,
      labelStyle: TextStyle(color: AppThemeConstants.textDark),
      floatingLabelStyle: TextStyle(color: AppThemeConstants.textDark),
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
              .textDark, // Cor do cursor// Cor do "pino" de seleção
    ),
  );
}

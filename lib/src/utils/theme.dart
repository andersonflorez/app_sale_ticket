import 'package:flutter/material.dart';

final ThemeData customTheme = ThemeData(
  fontFamily: 'SpaceGrotesk', // Usa esta fuente en toda la app
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontWeight: FontWeight.w700),
  ),
  brightness: Brightness.light,
  primaryColor: Colors.indigo,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.indigo,
    secondary: Colors.amber,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.indigo, width: 2),
    ),
    hintStyle: const TextStyle(color: Colors.grey),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      elevation: 6,
      shadowColor: Colors.indigo.withOpacity(0.4),
    ),
  ),
);

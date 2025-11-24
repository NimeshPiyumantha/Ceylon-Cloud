import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dark_theme.dart';
import 'font_theme.dart';
import 'light_theme.dart';

class LogicContextThemeManager {
  late ThemeData lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    textTheme: fontTheme,
    useMaterial3: true,
    cardTheme: const CardThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF7F8F9),
      labelStyle: TextStyle(
        color: const Color(0xFF8391A1),
        fontWeight: FontWeight.w400,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        fontSize: 16.0,
      ),
      hintStyle: TextStyle(
        color: const Color(0xFF8391A1),
        fontWeight: FontWeight.w400,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        fontSize: 16.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[200]!, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[200]!, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[200]!, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 12.0,
      ),
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0, // No shadow
      centerTitle: true, // Center title text
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(Colors.deepOrange),
      ),
    ),
  );

  late ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    textTheme: fontTheme,
    useMaterial3: true,
    cardTheme: const CardThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0XFF484848),
      labelStyle: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontWeight: FontWeight.w400,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        fontSize: 16.0,
      ),
      hintStyle: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontWeight: FontWeight.w400,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        fontSize: 16.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0XFF484848), width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0XFF484848), width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0XFF484848), width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 12.0,
      ),
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0, // No shadow
      centerTitle: true, // Center title text
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(Colors.deepOrange),
      ),
    ),
  );
}

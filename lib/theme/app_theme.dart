import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF07080D);
  static const Color backgroundSoft = Color(0xFF10121B);
  static const Color surface = Color(0xFF151823);
  static const Color surfaceElevated = Color(0xFF1D2130);
  static const Color accent = Color(0xFF7C5CFF);
  static const Color accent2 = Color(0xFF00D4FF);
  static const Color success = Color(0xFF32D583);
  static const Color warning = Color(0xFFFFC857);
  static const Color danger = Color(0xFFFF5470);
  static const Color muted = Color(0xFF8E96AA);
  static const Color text = Color(0xFFF7F8FF);

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(primary: accent, secondary: accent2, surface: surface, error: danger),
      textTheme: base.textTheme.apply(fontFamily: 'Poppins', bodyColor: text, displayColor: text),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, centerTitle: false),
      cardTheme: CardThemeData(color: surface, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        hintStyle: const TextStyle(color: muted),
        labelStyle: const TextStyle(color: muted),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: const BorderSide(color: accent, width: 1.4)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), textStyle: const TextStyle(fontWeight: FontWeight.w700))),
    );
  }

  static BoxDecoration screenGradient() {
    return const BoxDecoration(
      gradient: RadialGradient(center: Alignment(-0.85, -0.95), radius: 1.25, colors: [Color(0xFF1A1740), background]),
    );
  }
}

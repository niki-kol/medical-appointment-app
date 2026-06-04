import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand colors ────────────────────────────────────────────────────────────
  // Teal palette
  static const Color _teal900 = Color(0xFF072E29);
  static const Color _teal800 = Color(0xFF0D4F46);
  static const Color _teal600 = Color(0xFF1A7A6E);
  static const Color _teal400 = Color(0xFF2A9D8F);
  static const Color _teal200 = Color(0xFF5DCAA5);
  static const Color _teal100 = Color(0xFFB3DDD6);
  static const Color _teal50 = Color(0xFFE6F4F1);

  // Neutral warm palette
  static const Color _warm50 = Color(0xFFF8F6F2);
  static const Color _warm100 = Color(0xFFEDEBE7);
  static const Color _warm200 = Color(0xFFD3D1CB);
  static const Color _warm500 = Color(0xFF8A8880);
  static const Color _warm700 = Color(0xFF4A4844);
  static const Color _warm900 = Color(0xFF1A1A18);

  // Dark surface palette
  static const Color _dark900 = Color(0xFF0F0F0E);
  static const Color _dark800 = Color(0xFF161715);
  static const Color _dark700 = Color(0xFF1E201E);
  static const Color _dark600 = Color(0xFF272927);
  static const Color _dark400 = Color(0xFF3A3D3A);

  // Semantic
  static const Color _error = Color(0xFFBA1A1A);
  static const Color _errorDark = Color(0xFFFFB4AB);
  //static const Color _orange     = Color(0xFFE07B39);
  //static const Color _orangeDark = Color(0xFFFFB77C);

  // ── Light Theme ─────────────────────────────────────────────────────────────
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: _teal600,
      onPrimary: Colors.white,
      primaryContainer: _teal50,
      onPrimaryContainer: _teal800,
      secondary: _teal400,
      onSecondary: Colors.white,
      secondaryContainer: _teal100,
      onSecondaryContainer: _teal800,
      surface: _warm50,
      onSurface: _warm900,
      surfaceContainerHighest: _warm100,
      onSurfaceVariant: _warm700,
      outline: _warm200,
      outlineVariant: Color(0xFFE8E6E2),
      error: _error,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
    ),
    scaffoldBackgroundColor: _warm50,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: _warm900,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: _warm900,
        letterSpacing: -0.2,
      ),
      iconTheme: IconThemeData(color: _warm700, size: 22),
      actionsIconTheme: IconThemeData(color: _warm700, size: 22),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE8E6E2)),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _warm100.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _warm200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _warm200.withValues(alpha: 0.8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _teal600, width: 1.5),
      ),
      labelStyle: TextStyle(
        fontSize: 13,
        color: _warm700.withValues(alpha: 0.8),
      ),
      hintStyle: TextStyle(fontSize: 14, color: _warm500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _teal600,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _teal600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _teal600,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _teal600,
        side: const BorderSide(color: _teal100, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEAE8E4),
      thickness: 1,
      space: 1,
    ),
    iconTheme: const IconThemeData(color: _warm700, size: 22),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _warm900,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFFEAE8E4)),
      ),
    ),
  );

  // ── Dark Theme ───────────────────────────────────────────────────────────────
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: _teal400,
      onPrimary: _teal900,
      primaryContainer: _teal800,
      onPrimaryContainer: _teal50,
      secondary: _teal200,
      onSecondary: _teal900,
      secondaryContainer: _teal600,
      onSecondaryContainer: _teal50,
      surface: _dark700,
      onSurface: Color(0xFFE4E2DE),
      surfaceContainerHighest: _dark600,
      onSurfaceVariant: Color(0xFFB0AEA8),
      outline: _dark400,
      outlineVariant: _dark600,
      error: _errorDark,
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
    ),
    scaffoldBackgroundColor: _dark800,
    appBarTheme: const AppBarTheme(
      backgroundColor: _dark700,
      foregroundColor: Color(0xFFE4E2DE),
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE4E2DE),
        letterSpacing: -0.2,
      ),
      iconTheme: IconThemeData(color: Color(0xFFB0AEA8), size: 22),
      actionsIconTheme: IconThemeData(color: Color(0xFFB0AEA8), size: 22),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: _dark700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _dark400),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _dark600.withValues(alpha: 0.6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _dark400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _dark400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _teal400, width: 1.5),
      ),
      labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF909088)),
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF706E68)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _teal400,
        foregroundColor: _teal900,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _teal400,
        foregroundColor: _teal900,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _teal400,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _teal400,
        side: const BorderSide(color: _teal800, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: _dark400,
      thickness: 1,
      space: 1,
    ),
    iconTheme: const IconThemeData(color: Color(0xFFB0AEA8), size: 22),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFFE4E2DE),
      contentTextStyle: const TextStyle(color: _dark900, fontSize: 13),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: _dark700,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: _dark700,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: _dark400),
      ),
    ),
  );

  static Color getBookedSlotColor(BuildContext context) {
    return Theme.of(context).colorScheme.primaryContainer;
  }

  static Color getEmptySlotColor(BuildContext context, int index) {
    return Theme.of(
      context,
    ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35);
  }

  static Color getSlotBorderColor(BuildContext context, bool isBooked) {
    final scheme = Theme.of(context).colorScheme;
    return isBooked
        ? scheme.primary.withValues(alpha: 0.4)
        : scheme.outline.withValues(alpha: 0.12);
  }
}

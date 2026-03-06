import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - Greenish-Grey Tech Theme with Dark Mode
  static final Color primaryGreen = const Color(0xFF059669); // Green primary
  static final Color greenishGrey = const Color(0xFF4B7F6A); // Greenish-Grey
  static final Color darkGrey = const Color(0xFF2D3E35); // Dark grey-green
  static final Color veryDarkBg =
      const Color(0xFF1A2421); // Very dark grey-green background
  static final Color lightGreen = const Color(0xFFF0F6F3); // Light green tint
  static final Color accentGreen = const Color(0xFF10B981); // Emerald accent
  static final Color success = const Color(0xFF10B981); // Green
  static final Color warning = const Color(0xFFF59E0B); // Amber
  static final Color error = const Color(0xFFEF4444); // Red
  static final Color info = const Color(0xFF059669); // Green info

  // Light Theme - Greenish-Grey
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: greenishGrey, // Greenish-Grey primary
      secondary: accentGreen, // Emerald accent
      tertiary: primaryGreen, // Green accent
      surface: const Color(0xFFFAFBFA), // Very light off-white
      background: lightGreen, // Light green tinted background
      error: error,
    ),
    scaffoldBackgroundColor: lightGreen,
    primaryColor: greenishGrey,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFFAFBFA),
      foregroundColor: greenishGrey,
      elevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: greenishGrey,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: greenishGrey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: greenishGrey,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: greenishGrey,
        side: BorderSide(color: greenishGrey, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: greenishGrey,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFAFBFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: greenishGrey, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade700),
      hintStyle: TextStyle(color: Colors.grey.shade500),
      prefixIconColor: greenishGrey,
      suffixIconColor: greenishGrey,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: const Color(0xFFFAFBFA),
      surfaceTintColor: greenishGrey,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade100,
      selectedColor: greenishGrey,
      labelStyle: TextStyle(color: Colors.grey.shade800),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Colors.grey.shade900,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade900,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade900,
        letterSpacing: 0.2,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade800,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey.shade700,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade600,
      ),
    ),
  );

  // Dark Theme - Greenish-Grey Developer-Focused
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: accentGreen, // Bright green accent
      secondary: const Color(0xFF4B7F6A), // Greenish-grey
      tertiary: primaryGreen, // Green
      surface: darkGrey, // Dark grey-green
      background: veryDarkBg, // Very dark grey-green background
      error: error,
    ),
    scaffoldBackgroundColor: veryDarkBg, // Very dark grey-green background
    primaryColor: accentGreen,
    appBarTheme: AppBarTheme(
      backgroundColor: darkGrey,
      foregroundColor: accentGreen,
      elevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: accentGreen,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: accentGreen),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentGreen,
        side: BorderSide(color: accentGreen, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentGreen,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkGrey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accentGreen, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade400),
      hintStyle: TextStyle(color: Colors.grey.shade600),
      prefixIconColor: accentGreen,
      suffixIconColor: accentGreen,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: darkGrey,
      surfaceTintColor: accentGreen,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade800,
      selectedColor: accentGreen,
      labelStyle: TextStyle(color: Colors.grey.shade200),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Colors.grey.shade100,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade100,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade100,
        letterSpacing: 0.2,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade200,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade200,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey.shade400,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade500,
      ),
    ),
  );
}

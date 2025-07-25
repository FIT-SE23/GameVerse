import 'package:flutter/material.dart';

class DarkThemeColors {
  DarkThemeColors._();

  static const Color background = Color(0xFF141414);
  static const Color text = Color(0xFFFFFFFF);
  static const Color shell = Color(0xFF252525);
  static const Color onShell = Color(0xFFFFFFFF);

  static const Color cyan = Color(0xFF47FFE7);
  static const Color onCyan = Color(0xFF141414);
}

class LightThemeColors {
  LightThemeColors._();

  static const Color background = Color(0xFFDADADA);
  static const Color shell = Color(0xFFEBEBEB);
  static const Color text = Color(0xFF141414);

  static const Color cyan = Color(0xFF20CFC2);
  static const Color onCyan = Color(0xFFFFFFFF);
}

class AppTheme {
  // DARK THEME
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Play',
    
    // Base colors
    primaryColor: DarkThemeColors.cyan,      // Primary blue - main brand color
    scaffoldBackgroundColor: DarkThemeColors.background, // App background
    
    colorScheme: const ColorScheme.dark(
      primary: DarkThemeColors.cyan,         // Primary buttons, active states
      onPrimary: Colors.white,            // Text/icons on primary color
      primaryContainer: Color(0xFF173B5A), // Secondary buttons, containers
      onPrimaryContainer: Color(0xFFBFE0FF), // Text on primary containers
      
      secondary: DarkThemeColors.cyan,       // Accent color for highlights
      onSecondary: DarkThemeColors.onCyan,          // Text on secondary color
      secondaryContainer: Color(0xFF0D2F49), // Secondary containers
      onSecondaryContainer: Color(0xFFB8E5FF), // Text on secondary containers
      
      surface: Color(0xFF1E1E1E),         // Cards, dialogs background
      onSurface: Color(0xFFE0E0E0),       // Text on surface
      surfaceContainerHighest: Color(0xFF2D2D2D),  // Alternative surface
      onSurfaceVariant: Color(0xFFB0B0B0), // Secondary text
      
      error: Color(0xFFCF6679),           // Error states
      onError: Colors.black,              // Text on error color
      
      outline: Color(0xFF444444),         // Borders, dividers
    ),
    
    // Card theme
    cardTheme: CardThemeData(
      color: Color(0xFF1E1E1E),           // Card background
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    
    // App bar
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkThemeColors.shell,  // App bar background
      foregroundColor: DarkThemeColors.onShell,  // App bar text/icons
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20, 
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // Elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkThemeColors.cyan, // Button background
        foregroundColor: DarkThemeColors.onCyan,           // Button text
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    
    // Text buttons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DarkThemeColors.cyan, // Text button color
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    
    // Outlined buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DarkThemeColors.cyan, // Text color
        side: const BorderSide(color: Color(0xFF444444)), // Border color
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    
    // Input fields
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF2D2D2D),       // Input background
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Color(0xFF444444)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: DarkThemeColors.cyan, width: 2),
      ),
    ),
    
    // Text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: DarkThemeColors.text),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DarkThemeColors.text),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: DarkThemeColors.text),
      
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: DarkThemeColors.text),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: DarkThemeColors.text),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: DarkThemeColors.text),
      
      bodyLarge: TextStyle(fontSize: 16, color: DarkThemeColors.text),
      bodyMedium: TextStyle(fontSize: 14, color: DarkThemeColors.text),
      bodySmall: TextStyle(fontSize: 12, color: DarkThemeColors.text),
    ),
    
    // Bottom navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),   // Bottom nav background
      selectedItemColor: Color(0xFF66c0f4), // Selected icon color
      unselectedItemColor: Color(0xFF8E8E8E), // Unselected icon color
    ),
    
    // Dialog theme
    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    ),
  );

  // LIGHT THEME
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Play',
    
    // Base colors
    primaryColor: LightThemeColors.cyan,    // Primary blue - main brand color
    scaffoldBackgroundColor: LightThemeColors.background,    // App background
    
    colorScheme: const ColorScheme.light(
      primary: LightThemeColors.cyan,        // Primary buttons, active states
      onPrimary: Colors.white,           // Text/icons on primary color
      primaryContainer: Color.fromARGB(255, 41, 119, 254), // Secondary buttons, containers
      onPrimaryContainer: Color.fromARGB(255, 255, 255, 255), // Text on primary containers
      
      secondary: LightThemeColors.cyan,      // Accent color for highlights
      onSecondary: LightThemeColors.onCyan,         // Text on secondary color
      secondaryContainer: Color(0xFFD4E9FF), // Secondary containers
      onSecondaryContainer: Color(0xFF00497D), // Text on secondary containers
      
      surface: Colors.white,             // Cards, dialogs background
      onSurface: Color(0xFF1F1F1F),      // Text on surface
      surfaceContainerHighest: Color(0xFFF2F2F2), // Alternative surface
      onSurfaceVariant: Color(0xFF5F5F5F), // Secondary text
      
      error: Color(0xFFB00020),          // Error states
      onError: Colors.white,             // Text on error color
      
      outline: Color(0xFFDDDDDD),        // Borders, dividers
    ),
    
    // Card theme
    cardTheme: CardThemeData(
      color: Colors.white,               // Card background
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: Color(0xFFEEEEEE)),
      ),
    ),
    
    // App bar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),      // App bar background
      foregroundColor: Color(0xFF1F1F1F), // App bar text/icons
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Color(0xFF1F1F1F),
        fontSize: 20, 
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // Elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightThemeColors.cyan, // Button background
        foregroundColor: LightThemeColors.onCyan,           // Button text
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    
    // Text buttons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: LightThemeColors.cyan, // Text button color
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    
    // Outlined buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: LightThemeColors.cyan, // Text color
        side: const BorderSide(color: Color(0xFFDDDDDD)), // Border color
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    
    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,          // Input background
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Color(0xFFDDDDDD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: LightThemeColors.cyan, width: 2),
      ),
    ),
    
    // Text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: LightThemeColors.text),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: LightThemeColors.text),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: LightThemeColors.text),
      
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: LightThemeColors.text),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: LightThemeColors.text),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: LightThemeColors.text),
      
      bodyLarge: TextStyle(fontSize: 16, color: LightThemeColors.text),
      bodyMedium: TextStyle(fontSize: 14, color: LightThemeColors.text),
      bodySmall: TextStyle(fontSize: 12, color: LightThemeColors.text),
    ),
    
    // Bottom navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,       // Bottom nav background
      selectedItemColor: Color(0xFF1a73e8), // Selected icon color
      unselectedItemColor: Color(0xFF757575), // Unselected icon color
    ),
    
    // Dialog theme
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    ),
  );
}
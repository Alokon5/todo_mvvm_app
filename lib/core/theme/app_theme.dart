// import 'package:flutter/material.dart';

// class AppTheme {
//   static final lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primarySwatch: Colors.blue,
//     scaffoldBackgroundColor: Colors.white,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.blue,
//       foregroundColor: Colors.white,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//     ),
//     textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
//     listTileTheme: const ListTileThemeData(textColor: Colors.black87),
//     checkboxTheme: CheckboxThemeData(fillColor: WidgetStateProperty.all(Colors.blue)),
//   );

//   static final darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primarySwatch: Colors.blue,
//     scaffoldBackgroundColor: Colors.grey[900],
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.grey[850],
//       foregroundColor: Colors.white,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//     ),
//     textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
//     listTileTheme: const ListTileThemeData(textColor: Colors.white70),
//     checkboxTheme: CheckboxThemeData(fillColor: WidgetStateProperty.all(Colors.blue[700])),
//   );
// }
import 'package:flutter/material.dart';

class AppTheme {
  static final teal = MaterialColor(0xFF009688, {
    50: Color(0xFFE0F2F1),
    100: Color(0xFFB2DFDB),
    200: Color(0xFF80CBC4),
    300: Color(0xFF4DB6AC),
    400: Color(0xFF26A69A),
    500: Color(0xFF009688),
    600: Color(0xFF00897B),
    700: Color(0xFF00796B),
    800: Color(0xFF00695C),
    900: Color(0xFF004D40),
  });

  static final orange = MaterialAccentColor(0xFFFF5722, {
    100: Color(0xFFFF8A65),
    200: Color(0xFFFF5722),
    400: Color(0xFFFF3D00),
    700: Color(0xFFE64A19),
  });

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: teal,
    scaffoldBackgroundColor: Color(0xFFF8FAFB),
    cardColor: Colors.white,
    dividerColor: Colors.grey[300],
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.grey[600]),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.grey[700]),
    ),
    iconTheme: IconThemeData(color: Colors.grey[600]),
    colorScheme: ColorScheme.light(
      primary: teal,
      secondary: orange,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: teal,
    scaffoldBackgroundColor: Color(0xFF121212),
    cardColor: Color(0xFF1E1E1E),
    dividerColor: Colors.grey[800],
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white60),
    ),
    iconTheme: IconThemeData(color: Colors.white60),
    colorScheme: ColorScheme.dark(
      primary: teal[400]!,
      secondary: orange,
    ),
  );
}

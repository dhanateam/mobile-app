import 'package:flutter/material.dart';

class CustomColorScheme {
  final Color customBlue;
  final Color customGreen;
  final Color customRed;
  final Color customYellow;
  final Color customGrey;
  final Color shadowColor;
  final Color iconColor;
  final Color textColor;

  CustomColorScheme({
    required this.customBlue,
    required this.customGreen,
    required this.customRed,
    required this.customYellow,
    required this.customGrey,
    required this.shadowColor,
    required this.iconColor,
    required this.textColor,
  });
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData {
    return ThemeData(
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

  CustomColorScheme get customColors {
    return _isDarkMode
        ? CustomColorScheme(
            customBlue: Colors.blueGrey[900]!,
            customGreen: Colors.green[900]!,
            customRed: Colors.red[900]!,
            customYellow: Colors.amber[700]!,
            customGrey: Colors.grey[850]!,
            shadowColor: Colors.white.withOpacity(0.1),
            iconColor: Color.fromARGB(255, 238, 232, 219), // Wheatish color for icons
            textColor:  Color.fromARGB(255, 238, 232, 219), // Wheatish color for text
          )
        : CustomColorScheme(
            customBlue: Colors.blueAccent,
            customGreen: Colors.greenAccent,
            customRed: Colors.redAccent,
            customYellow: Colors.yellowAccent,
            customGrey: Colors.grey.shade300,
            shadowColor: Colors.black.withOpacity(0.1),
            iconColor: Colors.black,
            textColor: Colors.black,
          );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

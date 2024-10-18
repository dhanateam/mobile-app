import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomColorScheme {
  final Color customBlue;
  final Color customGreen;
  final Color customRed;
  final Color customYellow;
  final Color customGrey;
  final Color shadowColor;
  final Color iconColor;
  final Color textColor;
  final Color buttonColor;

  CustomColorScheme({
    required this.customBlue,
    required this.customGreen,
    required this.customRed,
    required this.customYellow,
    required this.customGrey,
    required this.shadowColor,
    required this.iconColor,
    required this.textColor,
    required this.buttonColor,
  });
}

class ThemeProvider with ChangeNotifier, WidgetsBindingObserver {
  bool _isDarkMode = false;

  ThemeProvider() {
    // Check the system theme on initial load
    _isDarkMode =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

    WidgetsBinding.instance.addObserver(this); // Start observing system changes
  }

  @override
  void didChangePlatformBrightness() {
    // Update the theme when the platform brightness changes
    final Brightness brightness =
        WidgetsBinding.instance.window.platformBrightness;
    _isDarkMode = (brightness == Brightness.dark);
    notifyListeners(); // Notify to update the UI based on system brightness
  }

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
            customYellow: Colors.amber[700]!,
            customGrey: Colors.grey[850]!,
            shadowColor: Colors.white.withOpacity(0.1),
            customRed: Colors.redAccent,
            customGreen: Colors.greenAccent,
            iconColor:
                Color.fromARGB(255, 238, 232, 219), // Wheatish color for icons
            textColor:
                Color.fromARGB(255, 238, 232, 219), // Wheatish color for text
            buttonColor: Colors.orangeAccent,
          )
        : CustomColorScheme(
            customRed: Colors.red[900]!,
            customGreen: Colors.green[900]!,
            customBlue: Colors.blueAccent,
            customYellow: Colors.yellowAccent,
            customGrey: Colors.grey.shade300,
            shadowColor: Colors.black.withOpacity(0.1),
            iconColor: Colors.black,
            textColor: Colors.black,
            buttonColor: Colors.deepOrange,
          );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Clean up observer when not needed
    super.dispose();
  }
}

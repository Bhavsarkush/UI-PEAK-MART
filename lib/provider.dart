import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;

  ThemeProvider() {
    _loadTheme(); // Load the theme when initialized
  }

  ThemeData get currentTheme => _currentTheme;

  // Getter to check if the current theme is dark
  bool get isDarkMode => _currentTheme.brightness == Brightness.light;

  // Load the theme from SharedPreferences
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDarkTheme = prefs.getBool('isDarkTheme');
    _currentTheme = isDarkTheme == true ? ThemeData.dark() : ThemeData.light();
    notifyListeners(); // Notify listeners after loading the theme
  }

  // Toggle the theme and update SharedPreferences
  Future<void> toggleTheme() async {
    bool isCurrentlyDark = _currentTheme.brightness == Brightness.dark; // Determine current state
    _currentTheme = isCurrentlyDark ? ThemeData.light() : ThemeData.dark(); // Switch the theme
    notifyListeners(); // Notify listeners about the change
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', !isCurrentlyDark); // Save the new theme state
  }
}

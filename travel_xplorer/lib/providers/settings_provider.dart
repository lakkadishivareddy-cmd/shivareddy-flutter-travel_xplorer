import 'package:flutter/material.dart';

/// App-level settings: theme mode and the traveller's display name.
class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _userName = 'Traveller';

  ThemeMode get themeMode => _themeMode;
  String get userName => _userName;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name.trim();
    notifyListeners();
  }
}

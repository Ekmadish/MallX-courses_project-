import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  accentColor: Colors.pink,
  scaffoldBackgroundColor: Colors.white,
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  accentColor: Colors.pink,
);

class ThemeNotifire extends ChangeNotifier {
  final String key = 'theme';
  SharedPreferences _preferences;
  bool _darkTheme;
  bool get darkTheme => _darkTheme;

  ThemeNotifire() {
    _darkTheme = true;
    _loadPrefs();
  }

  ToggleTheme() {
    _darkTheme = !_darkTheme;
    _savePrefs();
    ChangeNotifier();
    notifyListeners();
  }

  _initPrefs() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

  _loadPrefs() async {
    await _initPrefs();

    _darkTheme = _preferences.getBool(key) ?? true;

    notifyListeners();
    ChangeNotifier();
  }

  _savePrefs() async {
    await _initPrefs();

    _preferences.setBool(key, _darkTheme);
  }
}

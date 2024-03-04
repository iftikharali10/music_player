import 'package:flutter/material.dart';
import 'package:music_player/pages/dark_mode.dart';
import 'package:music_player/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier{
  // Initially make it light mode 
  ThemeData _themeData = lightMode;

  // get theme 
  ThemeData get themeData => _themeData;

  // is dark mode 
  bool get isDarkMOde => _themeData == darkMode;

  // set theme 
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    
    // update the UI
    notifyListeners();
  }
  // toggle theme method 
  void toggleTheme () {
    if (_themeData == lightMode) {
      themeData = darkMode;
      
    } else {
      themeData = lightMode;
    }
  }
}
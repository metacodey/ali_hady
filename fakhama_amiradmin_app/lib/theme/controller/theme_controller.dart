import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../core/class/preferences.dart';

class ThemeController extends GetxController implements GetxService {
  ThemeController() {
    _loadCurrentTheme();
  }

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    Preferences.setBoolean(Preferences.themeApp, _darkTheme);
    _updateGetThemeMode();
    update();
  }

  void changeThemeToWhite() {
    _darkTheme = false;
    Preferences.setBoolean(Preferences.themeApp, _darkTheme);
    _updateGetThemeMode();
    update();
  }

  void _loadCurrentTheme() async {
    _darkTheme = Preferences.getBoolean(Preferences.themeApp);
    _updateGetThemeMode();
    update();
  }

  void _updateGetThemeMode() {
    Get.changeThemeMode(_darkTheme ? ThemeMode.dark : ThemeMode.light);
  }
}

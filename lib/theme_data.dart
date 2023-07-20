import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

var lightThemeData = ThemeData(
    useMaterial3: true,
    navigationBarTheme: const NavigationBarThemeData(
      surfaceTintColor: Colors.white,
    ));
var darkThemeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark().copyWith(background: Colors.black),
    navigationBarTheme: const NavigationBarThemeData(
        surfaceTintColor: Colors.black, backgroundColor: Colors.black));
const settingsLightTheme = SettingsThemeData(
  settingsListBackground: Colors.white,
  settingsSectionBackground: Colors.white,
);
const settingsDarkTheme = SettingsThemeData(
  settingsListBackground: Colors.black,
  settingsSectionBackground: Colors.black,
);

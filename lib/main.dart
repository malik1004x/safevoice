import 'package:flutter/material.dart';
import "package:safevoice/theme_data.dart";
import "encryptor.dart";
import "password_setup_page.dart";
import "main_navigator.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:package_info_plus/package_info_plus.dart';

late SharedPreferences prefs;
late PackageInfo info;
const recordingsFolderName = "recs";
const defaultFileName = "Recording";
// TODO IAP integration and some purchase-worthy features.
const isDemoVersion = false;
const productName = "SafeVoice";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  info = await PackageInfo.fromPlatform();
  ensureRecordingsDirectoryExists();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var keysSaved = hasKeys();
  var isDarkMode = prefs.getBool("settings.darkmode") ?? false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Secure voice recorder',
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: keysSaved
            ? const MainNavigator()
            : PasswordSetupPage(
                firstSetup: true,
                onSetupCompleted: () {
                  setState(() {
                    keysSaved = true;
                  });
                }));
  }
}

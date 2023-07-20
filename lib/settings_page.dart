import 'package:flutter/material.dart';
import 'dialog_boxes.dart';
import 'password_setup_page.dart';
import 'package:settings_ui/settings_ui.dart';
import 'about_page.dart';
import 'main.dart';
import 'theme_data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SettingsList(
        lightTheme: settingsLightTheme,
        darkTheme: settingsDarkTheme,
        sections: [
          if (isDemoVersion)
            SettingsSection(title: const Text("Demo version"), tiles: [
              _openPage(const Placeholder(), "Purchase full version!",
                  "Make the dev really happy.", Icons.attach_money)
            ]),
          SettingsSection(title: const Text("General"), tiles: [
            _changeBoolean("darkmode", "Dark mode",
                "Darker colors for the app.", Icons.nightlight_outlined,
                restartRequired: true),
            _changeBoolean(
                "show_fractions",
                "Detailed timer",
                "Show fractions of seconds on the recording timer.",
                Icons.timer)
            // _changeBoolean(
            //     "geotag",
            //     "Tag with location",
            //     "Autoname your recordings with your current location.",
            //     Icons.location_on_outlined),
          ]),
          SettingsSection(
            title: const Text("Security"),
            tiles: [
              _openPage(
                  PasswordSetupPage(
                      onSetupCompleted: () {
                        Navigator.of(context).pop();
                      },
                      firstSetup: false),
                  "Change password",
                  "Change decryption password.",
                  Icons.password),
              _changeBoolean(
                  "alphanumeric_password",
                  "Alphanumeric password",
                  "Allow for a password with both letters and numbers.",
                  Icons.abc),
            ],
          ),
          SettingsSection(
            title: const Text("Info"),
            tiles: [
              _openPage(const LicensePage(), "Open source licenses",
                  "View open source licenses for the app.", Icons.list_alt),
              _openPage(const AboutPage(), "About $productName...",
                  "Version ${info.version}", Icons.info_outline)
            ],
          )
        ],
      ),
    );
  }

  AbstractSettingsTile _changeBoolean(
      String element, String title, String description, IconData icon,
      {bool restartRequired = false}) {
    return SettingsTile.switchTile(
        initialValue: prefs.getBool("settings.$element"),
        onToggle: ((value) {
          prefs.setBool("settings.$element", value);
          setState(() {});
          if (restartRequired) {
            showRestartRequiredDialogBox(context);
          }
        }),
        title: Text(title),
        description: Text(description),
        leading: Icon(icon));
  }

  AbstractSettingsTile _openPage(
      Widget page, String title, String description, IconData icon) {
    return SettingsTile.navigation(
        title: Text(title),
        description: Text(description),
        onPressed: (BuildContext context) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return page;
            }),
          );
        },
        leading: Icon(icon));
  }
}

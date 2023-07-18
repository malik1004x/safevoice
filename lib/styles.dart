import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

// static aesthetic stuff for ui elements.
const counterTextStyle = TextStyle(
  fontSize: 80,
  fontWeight: FontWeight.bold,
);
var recordButtonStyle = ButtonStyle(
    alignment: AlignmentDirectional.center,
    minimumSize: MaterialStateProperty.all(const Size(150, 150)));
var pauseButtonStyle =
    ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(70, 70)));
const recordIcon =
    Icon(Icons.fiber_manual_record, color: Colors.red, size: 80.0);
const stopIcon = Icon(Icons.stop, size: 80.0);
const listButtonContent = Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.list),
    SizedBox(width: 5.0),
    Text("Recording list"),
  ],
);
var listButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(70.0))),
    minimumSize: MaterialStateProperty.all(const Size(250, 50)));
const pauseIcon = Icon(Icons.pause, size: 40.0);
const resumeIcon = Icon(Icons.play_arrow, size: 40.0);
const lockButtonContent = Row(children: [Icon(Icons.lock), Text("Lock")]);
const pageHeaderTextStyle =
    TextStyle(fontSize: 35, fontWeight: FontWeight.bold);
const recordingListNameTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);
const aboutPageAppNameTextStyle = TextStyle(
  fontSize: 60,
  fontWeight: FontWeight.w300,
);
const aboutPageVersionTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w600,
);
const settingsLightTheme = SettingsThemeData(
  settingsListBackground: Colors.white,
  settingsSectionBackground: Colors.white,
);
const aboutPageIcon = Stack(alignment: AlignmentDirectional.center, children: [
  Icon(Icons.fiber_manual_record, color: Colors.red, size: 300.0),
  Icon(Icons.lock, color: Colors.white, size: 150.0),
]);
const decryptingProgressTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
const playButtonIcon = Stack(
  alignment: AlignmentDirectional.center,
  children: [
    // hacky little styling trick because button size parameter doesn't work properly.
    Icon(null, size: 70.0),
    Icon(Icons.play_arrow, size: 60.0),
  ],
);
const pauseButtonIcon = Stack(
  alignment: AlignmentDirectional.center,
  children: [
    // hacky little styling trick because button size parameter doesn't work properly.
    Icon(null, size: 70.0),
    Icon(Icons.pause, size: 60.0),
  ],
);
var playButtonStyle =
    ButtonStyle(shape: MaterialStateProperty.all(const CircleBorder()));
const playerRecordingNameTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
);
const passwordInputFieldTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w500,
);

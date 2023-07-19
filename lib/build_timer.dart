import 'package:flutter/material.dart';

Widget buildTimer(
    int time, TextStyle mainTimerStyle, TextStyle smallTimerStyle) {
  final String minutes = formatNumber(time ~/ 60000);
  final int secondsAndMilliseconds = time % 60000;
  final String seconds = formatNumber(secondsAndMilliseconds ~/ 1000);
  final String fractionsOfSeconds =
      formatNumber((secondsAndMilliseconds % 1000) ~/ 10);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.ideographic,
    children: [
      Text(
        '$minutes:$seconds',
        style: mainTimerStyle,
      ),
      Text(".$fractionsOfSeconds", style: smallTimerStyle),
      // crappy little debug thingie. i highly doubt i'll be needing this again.
      // Text(time.toString())
    ],
  );
}

String formatNumber(int number) {
  String numberStr = number.toString();
  if (number < 10) {
    numberStr = '0$numberStr';
  }

  return numberStr;
}

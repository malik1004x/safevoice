import 'package:flutter/material.dart';

Widget buildTimer(
    int time, TextStyle mainTimerStyle, TextStyle smallTimerStyle) {
  final String minutes = formatNumber(time ~/ 6000);
  final int secondsAndMilliseconds = time % 6000;
  final String seconds = formatNumber(secondsAndMilliseconds ~/ 100);
  final String milliseconds = formatNumber(secondsAndMilliseconds % 100);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.ideographic,
    children: [
      Text(
        '$minutes:$seconds',
        style: mainTimerStyle,
      ),
      Text(".$milliseconds", style: smallTimerStyle)
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

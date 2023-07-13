import 'package:flutter/material.dart';

Widget buildTimer(int time, TextStyle timerStyle) {
  final String minutes = formatNumber(time ~/ 60);
  final String seconds = formatNumber(time % 60);

  return Text(
    '$minutes:$seconds',
    style: timerStyle,
  );
}

String formatNumber(int number) {
  String numberStr = number.toString();
  if (number < 10) {
    numberStr = '0$numberStr';
  }

  return numberStr;
}

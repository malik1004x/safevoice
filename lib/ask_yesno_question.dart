import 'package:flutter/material.dart';

void askOKCancelQuestion(BuildContext context, String title, String message,
    void Function(bool result) onAnswered) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  onAnswered(true);
                  Navigator.of(context).pop();
                },
                child: const Text("OK")),
            TextButton(
                onPressed: () {
                  onAnswered(false);
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"))
          ],
        );
      });
}

import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String title, String message) {
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
                  Navigator.of(context).pop();
                },
                child: const Text("OK"))
          ],
        );
      });
}

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

Future<void> askForTextInDialog(BuildContext context,
    {required void Function(String result) onComplete,
    bool cancellable = true,
    required String title}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            autofocus: true,
            onSubmitted: (value) {
              onComplete(value);
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            if (cancellable)
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
          ],
        );
      });
}

import 'package:flutter/material.dart';

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

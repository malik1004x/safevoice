import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

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
              // this is in "reverse" order in case onComplete opens another page or displays a dialog box.
              Navigator.of(context).pop();
              onComplete(value);
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

void showRestartRequiredDialogBox(BuildContext context,
    {bool cancellable = false, void Function()? onCancelled}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Restart required"),
          content: const Text("The app will now reload."),
          actions: [
            if (cancellable)
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onCancelled != null) onCancelled();
                },
              ),
            TextButton(
              child: const Text("Restart"),
              onPressed: () {
                Restart.restartApp();
              },
            )
          ],
        );
      });
}

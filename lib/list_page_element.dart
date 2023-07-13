import 'package:flutter/material.dart';
import 'ask_yesno_question.dart';
import 'encryptor.dart';
import 'styles.dart';

import 'ask_for_text.dart';

class RecordingListPageElement extends StatefulWidget {
  const RecordingListPageElement(
      {super.key, required this.path, required this.date, required this.onTap});

  final String path;
  final String date;
  final void Function() onTap;

  @override
  State<RecordingListPageElement> createState() =>
      _RecordingListPageElementState();
}

class _RecordingListPageElementState extends State<RecordingListPageElement> {
  @override
  Widget build(BuildContext context) {
    String name = widget.path.split("/").last;
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: recordingListNameTextStyle),
              Text(widget.date),
            ],
          ),
          Row(
            children: [
              // disabled for now. will most likely be a full version-only feature
              // IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              IconButton(
                  onPressed: () {
                    askForTextInDialog(context, title: "Enter new name:",
                        onComplete: (result) {
                      renameRecording(widget.path, result);
                    });
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    askOKCancelQuestion(context, "Erase recording?",
                        "You cannot undo this action.", (result) {
                      if (result == true) eraseRecording(widget.path);
                    });
                  },
                  icon: const Icon(Icons.delete)),
            ],
          ),
        ],
      ),
    );
  }
}

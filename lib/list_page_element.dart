import 'package:flutter/material.dart';
import 'encryptor.dart';
import 'styles.dart';
import 'dialog_boxes.dart';

class RecordingListPageElement extends StatefulWidget {
  const RecordingListPageElement(
      {super.key,
      required this.path,
      required this.date,
      required this.onTap,
      required this.onUpdate});

  final String path;
  final String date;
  final void Function() onTap;
  final void Function() onUpdate;

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
                      try {
                        renameRecording(widget.path, result);
                        widget.onUpdate();
                      } on FileExistsException {
                        showErrorMessage(context, "File exists",
                            "A recording with this name already exists. Please try another name.");
                      }
                    });
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    askOKCancelQuestion(context, "Erase recording?",
                        "You cannot undo this action.", (result) {
                      if (result == true) {
                        eraseRecording(widget.path);
                        widget.onUpdate();
                      }
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

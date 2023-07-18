import "dart:io";
import "dart:typed_data";
import "package:fast_rsa/fast_rsa.dart";
import 'package:flutter/material.dart';
import "decrypting_widget.dart";
import "list_page_element.dart";
import "main.dart";
import "package:path_provider/path_provider.dart";
import "password_input_page.dart";
import "encryptor.dart";
import "player_widget.dart";
import "styles.dart";
import "dialog_boxes.dart";

class RecordingsList extends StatefulWidget {
  const RecordingsList({super.key});

  @override
  State<RecordingsList> createState() => _RecordingsListState();
}

class _RecordingsListState extends State<RecordingsList> {
  List<String> pathList = [];
  List<String> dateList = [];
  String currentPath = "";
  String privateKey = "";
  Uint8List? decryptedRecording;
  int failedPasswordAttempts = 0;

  @override
  Widget build(BuildContext context) {
    if (privateKey == "") {
      return PasswordInputPage(
        onCompleted: (List<String> answer) {
          setState(() {
            tryDecryption(answer[0]);
          });
        },
      );
    }
    _getRecordingsList();
    return SafeArea(
      child: Column(children: [
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recordings", style: pageHeaderTextStyle),
              OutlinedButton(
                  onPressed: _clearPrivateKey, child: lockButtonContent)
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 12.0),
                    child: RecordingListPageElement(
                      path: pathList[index],
                      date: dateList[index],
                      onTap: () {
                        setState(() {
                          currentPath = pathList[index];
                          decryptedRecording = null;
                        });
                        _getDecryptedRecording(pathList[index]);
                      },
                    ),
                  ),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: pathList.length),
        ),
        const Divider(),
        if (currentPath != "") _buildPlayer(),
      ]),
    );
  }

  void _getRecordingsList() async {
    var newPathList = <String>[];
    var newDateList = <String>[];

    final docsDir = await getApplicationDocumentsDirectory();
    final recsDir = Directory("${docsDir.path}/$recordingsFolderName/");

    // this sorts the recordings by date modified (newest first). seemed like the most logical approach.
    var recsList = recsDir.listSync().toList()
      ..sort((l, r) => r.statSync().modified.compareTo(l.statSync().modified));

    recsList.forEach((element) {
      newPathList.add(element.path);
      newDateList.add(element.statSync().modified.toIso8601String());
    });

    setState(() {
      pathList = newPathList;
      dateList = newDateList;
    });
  }

  void _clearPrivateKey() {
    setState(() {
      privateKey = "";
    });
  }

  Widget _buildPlayer() {
    if (decryptedRecording == null) {
      return const DecryptingProgressIndicator();
    } else {
      return PlayerWidget(
          name: currentPath.split("/").last, recording: decryptedRecording!);
    }
  }

  void _getDecryptedRecording(String path) async {
    final newDecryptedRecording = await decryptRecording(path, privateKey);
    setState(() {
      decryptedRecording = newDecryptedRecording;
    });
  }

  void tryDecryption(String password) async {
    try {
      final decryptedKey = await decryptPrivateKey(password);
      setState(() {
        privateKey = decryptedKey;
      });
    } on RSAException {
      showErrorMessage(
          context, "Incorrect password.", "That didn't work. Try again.");
      setState(() {
        failedPasswordAttempts += 1;
      });
    }
  }
}

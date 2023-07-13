import 'dart:io';
import 'dart:typed_data';
import "package:path_provider/path_provider.dart";
import 'package:fast_rsa/fast_rsa.dart';
import "main.dart";

void genKeys(String password) async {
  var keys = await RSA.generate(2048);
  prefs.setString("public_key", keys.publicKey);
  savePassword(keys.privateKey, password);
}

void savePassword(String privateKey, String newPassword) async {
  var newPrivateKeyEncrypted =
      await RSA.encryptPrivateKey(privateKey, newPassword, PEMCipher.AES256);
  prefs.setString("private_key_encrypted", newPrivateKeyEncrypted);
}

void encryptAndSaveRecording(String path, String filename) async {
  final file = File(path);
  final bytes = await File(path).readAsBytes();

  final docsDir = await getApplicationDocumentsDirectory();
  final savePath = "${docsDir.path}/$recordingsFolderName/$filename";

  final publicKey = prefs.getString("public_key")!;

  final encryptedRecording = await RSA.encryptPKCS1v15Bytes(bytes, publicKey);

  final encryptedFile = await File(savePath).create();
  await encryptedFile.writeAsBytes(encryptedRecording);

  // after we encrypt the recording, delete the original.
  await file.delete();
}

void eraseRecording(String path) async {
  final file = File(path);
  await file.delete();
}

void renameRecording(String path, String newName) async {
  final file = File(path);
  final oldName = path.split("/").last;
  final newPath = path.replaceAll(oldName, newName);
  file.rename(newPath);
}

Future<String> decryptPrivateKey(String password) async {
  final privateKeyEncrypted = prefs.getString("private_key_encrypted")!;
  return await RSA.decryptPrivateKey(privateKeyEncrypted, password);
}

Future<Uint8List> decryptRecording(String path, String privateKey) async {
  final file = File(path);
  final bytes = await file.readAsBytes();

  return await RSA.decryptPKCS1v15Bytes(bytes, privateKey);
}

void ensureRecordingsDirectoryExists() async {
  final docsDir = await getApplicationDocumentsDirectory();
  final recsDirPath = "${docsDir.path}/$recordingsFolderName";
  final recsDir = Directory(recsDirPath);

  if (!await recsDir.exists()) {
    await recsDir.create();
  }
}

Future<String> getNextAvailableNameSuffix(String name) async {
  // after getting "Recording" returns "Recording", "Recording 2", "Recording 3" etc.
  int currentNumber = 1;
  final docsDir = await getApplicationDocumentsDirectory();
  final recsDirPath = "${docsDir.path}/$recordingsFolderName";

  while (true) {
    var potentialName = currentNumber == 1 ? name : "$name $currentNumber";
    var exists = await File("$recsDirPath/$potentialName").exists();
    if (exists) {
      currentNumber++;
    } else {
      return potentialName;
    }
  }
}

bool hasKeys() {
  return prefs.getString("public_key") != null &&
      prefs.getString("private_key_encrypted") != null;
}

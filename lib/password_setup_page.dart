import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'encryptor.dart';
import 'password_input_page.dart';
import 'show_error_message.dart';

class PasswordSetupPage extends StatefulWidget {
  const PasswordSetupPage(
      {super.key, required this.onSetupCompleted, required this.firstSetup});

  final void Function() onSetupCompleted;
  final bool firstSetup;

  @override
  State<PasswordSetupPage> createState() => _PasswordSetupPageState();
}

class _PasswordSetupPageState extends State<PasswordSetupPage> {
  late List<String> hintTexts;

  @override
  void initState() {
    hintTexts = widget.firstSetup
        ? ["New password:", "Confirm password:"]
        : ["Old password:", "New password:", "Confirm password:"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PasswordInputPage(
          onCompleted: _handleSubmitted,
          hintTexts: hintTexts,
          numberOfSteps: widget.firstSetup ? 2 : 3,
        ),
      ),
    );
  }

  void _handleSubmitted(List<String> answers) async {
    if (answers[answers.length - 1] != answers[answers.length - 2]) {
      showErrorMessage(context, "Passwords don't match",
          "The passwords didn't match. Please try again.");
      return;
    }
    if (!widget.firstSetup) {
      try {
        final privateKey = await decryptPrivateKey(answers[0]);
        savePassword(privateKey, answers[1]);
      } on RSAException {
        showErrorMessage(context, "Incorrect password",
            "Please enter your old password correctly.");
        return;
      }
    } else {
      genKeys(answers[1]);
    }

    widget.onSetupCompleted();
  }
}

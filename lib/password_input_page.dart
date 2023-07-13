import 'package:flutter/material.dart';
import 'styles.dart';

import 'main.dart';

class PasswordInputPage extends StatefulWidget {
  const PasswordInputPage(
      {super.key,
      required this.onCompleted,
      this.hintTexts = const ["Enter password"],
      this.numberOfSteps = 1});

  final void Function(List<String> answers) onCompleted;
  final List<String> hintTexts;
  final int numberOfSteps;

  @override
  State<PasswordInputPage> createState() => _PasswordInputPageState();
}

class _PasswordInputPageState extends State<PasswordInputPage> {
  int currentStep = 1;
  var passwordInputController = TextEditingController();
  List<String> answers = [];
  bool alphanumericPassword =
      prefs.getBool("settings.alphanumeric_password") ?? false;
  late FocusNode inputFocusNode;

  @override
  void initState() {
    super.initState();
    inputFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50.0),
        Text(widget.hintTexts[currentStep - 1], style: pageHeaderTextStyle),
        const SizedBox(height: 60.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            style: passwordInputFieldTextStyle,
            keyboardType: alphanumericPassword
                ? TextInputType.text
                : TextInputType.number,
            textAlign: TextAlign.center,
            controller: passwordInputController,
            autofocus: true,
            focusNode: inputFocusNode,
            onSubmitted: (String password) {
              _onSubmitted(password);
            },
          ),
        )
      ],
    ));
  }

  void _onSubmitted(password) {
    setState(() {
      answers.add(password);
      passwordInputController.clear();
      inputFocusNode.requestFocus();
    });
    if (currentStep < widget.numberOfSteps) {
      setState(() {
        currentStep++;
      });
    } else {
      widget.onCompleted(answers);
      setState(() {
        currentStep = 1;
        answers = [];
      });
    }
  }

  @override
  void dispose() {
    inputFocusNode.dispose();
    super.dispose();
  }
}

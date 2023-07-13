import 'package:flutter/material.dart';
import 'styles.dart';

import 'main.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  static const easterEggTapsNeeded = 7;
  int easterEggTaps = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About $productName"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: aboutPageIcon,
              onTap: () {
                if (easterEggTaps > easterEggTapsNeeded) {
                  setState(() {
                    easterEggTaps = 0;
                  });
                  _showEasterEgg();
                }
                setState(() {
                  easterEggTaps++;
                });
              },
            ),
            const Text(productName, style: aboutPageAppNameTextStyle),
            Text("Version ${info.version}", style: aboutPageVersionTextStyle),
            const SizedBox(height: 30.0),
            const Text("Programmed by Robert Malikowski of malikstuff.net"),
            const Text("Proudly made in Poland 🇵🇱")
          ],
        ),
      ),
    );
  }

  void _showEasterEgg() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("You found my cow."),
            content: Image.asset("assets/cow.jpg"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Nice"))
            ],
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'styles.dart';

class DecryptingProgressIndicator extends StatelessWidget {
  const DecryptingProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 50.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularProgressIndicator(),
          Text("Decrypting...", style: decryptingProgressTextStyle)
        ],
      ),
    );
  }
}

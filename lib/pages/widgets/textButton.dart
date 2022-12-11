import 'package:flutter/material.dart';
import 'package:votantes/appConfig.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final VoidCallback function;
  const MyTextButton({super.key, required this.text, required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextButton(
        onPressed: () {
          function();
        },
        child: Text(text, style: AppCongig().prymaryTextStyle),
      ),
    );
  }
}

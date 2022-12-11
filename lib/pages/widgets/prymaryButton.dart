import 'package:flutter/material.dart';

class PrymaryButton extends StatefulWidget {
  final String text;
  final VoidCallback function;
  const PrymaryButton({super.key, required this.text, required this.function});

  @override
  State<PrymaryButton> createState() => _PrymaryButtonState();
}

class _PrymaryButtonState extends State<PrymaryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(15)),
        child: Text(
          widget.text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

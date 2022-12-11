import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final bool? isPass;
  final TextEditingController controller;
  final String labelText;
  final Icon icon;
  const MyTextField(
      {super.key,
      required this.controller,
      this.isPass,
      required this.icon,
      required this.labelText});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        fillColor: Colors.white,
        hoverColor: Colors.white,
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.white),
        focusColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white)),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final bool? isPass;
  final TextEditingController controller;
  final String labelText;
  final Icon icon;
  const MyTextField(
      {super.key,
      this.isPass = false,
      required this.controller,
      required this.icon,
      required this.labelText});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: widget.isPass! ? !_passwordVisible : false,
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        suffixIcon: widget.isPass!
            ? IconButton(
                alignment: Alignment.centerLeft,
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
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

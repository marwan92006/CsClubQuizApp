import 'package:flutter/material.dart';

class PasswordTextfield extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const PasswordTextfield(
      {super.key, required this.hintText, required this.obscureText,  required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        textInputAction: TextInputAction.newline,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              )),
          focusedBorder: (const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue))),
          fillColor: Colors.grey[200],
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}

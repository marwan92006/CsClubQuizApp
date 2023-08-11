import 'package:flutter/material.dart';

class QuestionsTextField extends StatelessWidget {
  final  controller;
  final String hintText;
  final bool obscureText;
  final color;

  const QuestionsTextField(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20)
      ),
      width: 160,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          minLines: 1,
          maxLines: 3,
          textInputAction: TextInputAction.newline,
          controller: controller,
          obscureText: obscureText,
          decoration:  InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.black,

            )),
            focusedBorder:
                ( const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))),
            fillColor: Colors.transparent,
            filled: true,
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}

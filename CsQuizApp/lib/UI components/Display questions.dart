import 'package:flutter/material.dart';

class QuestionDisplay extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final color;

  const QuestionDisplay(
      {super.key,
      required this.text,
      required this.color, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
        child: Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      width: 160,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ));
  }
}

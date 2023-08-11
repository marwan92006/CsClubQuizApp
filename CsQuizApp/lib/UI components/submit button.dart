import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final Function()? onpressed;
  const SubmitButton({super.key, this.onpressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed ,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          fixedSize: const Size(350, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child:  Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}

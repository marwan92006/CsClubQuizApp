
import 'package:flutter/material.dart';

class Squaretile extends StatelessWidget {
  final String imagespath;
  final double height;
  final Function()? onTap;
  const Squaretile({
    super.key,
    required this.imagespath,
    required this.height, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
        ),
        child: Image.asset(
          imagespath,
          height: height,
          width: 50,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Fancydividers extends StatelessWidget {
  const Fancydividers({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 0.7,
              color: Colors.white,
            ),
          ),
            Text('Or continue with', style: TextStyle(
            fontSize: 16,
              color: Colors.white,
          ),),
          Expanded(
            child: Divider(
              thickness: 0.7,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

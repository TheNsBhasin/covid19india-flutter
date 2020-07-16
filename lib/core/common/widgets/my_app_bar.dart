import 'package:flutter/material.dart';

class MyAppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: const TextSpan(
            text: 'COVID19',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEEEEEE)),
            children: [
          const TextSpan(
              text: 'IN',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent)),
          const TextSpan(
              text: 'D',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const TextSpan(
              text: 'IA',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent)),
        ]));
  }
}

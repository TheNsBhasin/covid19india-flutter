import 'package:flutter/material.dart';

PreferredSizeWidget covid19IndiaAppBar() {
  return AppBar(
    centerTitle: true,
    title: RichText(
        text: TextSpan(
            text: 'COVID19',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[200]),
            children: [
          TextSpan(
              text: 'IN',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent)),
          TextSpan(
              text: 'D',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: 'IA',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent)),
        ])),
  );
}

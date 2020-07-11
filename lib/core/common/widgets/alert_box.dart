import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  final Icon icon;
  final String text;

  AlertBox({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300].withAlpha(50),
          borderRadius: BorderRadius.all(new Radius.circular(5.0))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                  width: icon.size,
                  height: icon.size,
                  child: Container(
                    child: icon,
                  )),
            ),
            Expanded(
              child: Text(
                text,
                softWrap: true,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

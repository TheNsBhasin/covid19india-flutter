import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActionBar extends StatefulWidget {
  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  DateTime _now;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _now = new DateTime.now();

    _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _now = new DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 32.0, bottom: 16, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            new DateFormat('dd MMM, K:mm a').format(_now.toLocal()),
            style: TextStyle(color: Colors.grey),
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
              child: Icon(
                Icons.notifications,
                size: 16,
              ),
            ),
            onTap: () {},
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
              child: Icon(
                Icons.settings_backup_restore,
                size: 16,
              ),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}

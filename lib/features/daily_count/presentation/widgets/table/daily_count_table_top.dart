import 'dart:async';

import 'package:covid19india/core/common/widgets/sort_arrow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DailyCountTableTop extends StatefulWidget {
  final bool district;
  final bool perMillion;

  final Null Function() setDistrict;
  final Null Function() setPerMillion;

  DailyCountTableTop(
      {this.district, this.perMillion, this.setDistrict, this.setPerMillion});

  @override
  _DailyCountTableTopState createState() => _DailyCountTableTopState();
}

class _DailyCountTableTopState extends State<DailyCountTableTop> {
  bool help = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 8.0),
            IconButton(
              onPressed: () {
                widget.setDistrict();
              },
              icon: FaIcon(FontAwesomeIcons.building),
              color: widget.district ? Colors.red : Colors.grey,
            ),
            SizedBox(width: 8.0),
            IconButton(
              onPressed: () {
                widget.setPerMillion();
              },
              icon: FaIcon(FontAwesomeIcons.users),
              color: widget.perMillion ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 8.0),
            IconButton(
              onPressed: () {
                setState(() {
                  help = !help;
                });
              },
              icon: FaIcon(FontAwesomeIcons.questionCircle),
              color: help ? Colors.orange : Colors.grey,
            ),
            SizedBox(width: 8.0),
          ],
        ),
        if (help) DailyCountTableTopHelpPane()
      ],
    );
  }
}

class DailyCountTableTopHelpPane extends StatefulWidget {
  @override
  _DailyCountTableTopHelpPaneState createState() =>
      _DailyCountTableTopHelpPaneState();
}

class _DailyCountTableTopHelpPaneState extends State<DailyCountTableTopHelpPane>
    with SingleTickerProviderStateMixin {
  final Duration _animationDuration = new Duration(milliseconds: 1000);

  Color _color;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(_animationDuration, (timer) => _changeColor());
    _color = Colors.red;
  }

  @override
  void dispose() {
    super.dispose();

    _timer.cancel();
  }

  void _changeColor() {
    setState(() {
      if (_color == Colors.red) {
        _color = Colors.blue;
      } else if (_color == Colors.blue) {
        _color = Colors.green;
      } else if (_color == Colors.green) {
        _color = Colors.grey;
      } else if (_color == Colors.grey) {
        _color = Colors.purple;
      } else if (_color == Colors.purple) {
        _color = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey.withOpacity(0.2)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  FaIcon(
                    FontAwesomeIcons.building,
                    size: 12,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Toggle between States/Districts",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  )
                ]),
                SizedBox(height: 8.0),
                Row(children: [
                  FaIcon(
                    FontAwesomeIcons.users,
                    size: 12,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Per Million of Population",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  )
                ]),
                SizedBox(height: 8.0),
                Row(children: [
                  SortArrow(down: true),
                  SizedBox(width: 8),
                  Text(
                    "Sort by Descending",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  )
                ]),
                SizedBox(height: 8.0),
                Row(children: [
                  SortArrow(down: false),
                  SizedBox(width: 8),
                  Text(
                    "Sort by Ascending",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  )
                ]),
                SizedBox(height: 8.0),
                Row(children: [
                  AnimatedContainer(
                    duration: _animationDuration,
                    child: SortArrow(
                      down: true,
                      color: _color,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Sort by Delta [long press]",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  )
                ]),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Compiled from State Govt. numbers",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:covid19india/core/common/widgets/sort_arrow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DailyCountTableTop extends StatefulWidget {
  final Null Function(bool isSelected) setDistrict;
  final Null Function(bool isSelected) setPerMillion;

  DailyCountTableTop({this.setDistrict, this.setPerMillion});

  @override
  _DailyCountTableTopState createState() => _DailyCountTableTopState();
}

class _DailyCountTableTopState extends State<DailyCountTableTop> {
  bool district = false;
  bool perMillion = false;
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
                setState(() {
                  district = !district;
                  widget.setDistrict(district);
                });
              },
              icon: FaIcon(FontAwesomeIcons.building),
              color: district ? Colors.red : Colors.grey,
            ),
            SizedBox(width: 8.0),
            IconButton(
              onPressed: () {
                setState(() {
                  perMillion = !perMillion;
                  widget.setPerMillion(perMillion);
                });
              },
              icon: FaIcon(FontAwesomeIcons.users),
              color: perMillion ? Colors.green : Colors.grey,
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
        if (help)
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
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
                ],
              ),
            ),
          )
      ],
    );
  }
}

import 'package:covid19india/core/common/widgets/my_list_wheel_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Timeline extends StatefulWidget {
  final List<DateTime> timeline;
  final DateTime date;
  final void Function(DateTime date) setDate;

  Timeline({@required this.timeline, this.date, this.setDate});

  @override
  _TimelineState createState() =>
      _TimelineState(timeline: this.timeline, date: date);
}

class _TimelineState extends State<Timeline> {
  final List<DateTime> timeline;
  final DateTime date;
  final FixedExtentScrollController controller;

  int selectedIndex;

  _TimelineState({this.timeline, this.date})
      : selectedIndex = timeline.indexOf(date) == -1
            ? timeline.length - 1
            : timeline.indexOf(date),
        controller = new FixedExtentScrollController(
            initialItem: timeline.indexOf(date) == -1
                ? timeline.length - 1
                : timeline.indexOf(date));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        child: MyListWheelScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: FixedExtentScrollPhysics(),
          itemExtent: 100.0,
          magnification: 1.25,
          useMagnifier: true,
          childCount: timeline.length,
          renderChildrenOutsideViewport: false,
          onSelectedItemChanged: (int index) {
            setState(() {
              selectedIndex = index;
              widget.setDate(timeline[index]);
            });
          },
          builder: (context, int index) {
            return ListTile(
                selected: index == selectedIndex,
                title: Text(
                  _formatDate(timeline[index]),
                  style: TextStyle(fontSize: 14),
                ));
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime day) {
    final dateFormat = new DateFormat('dd MMM');
    String formattedDate = dateFormat.format(day.toLocal());

    if (formattedDate == dateFormat.format(new DateTime.now())) {
      return "Today";
    }

    return formattedDate;
  }
}

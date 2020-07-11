import 'package:covid19india/core/constants/constants.dart';
import 'package:flutter/material.dart';

class TimeSeriesPills extends StatelessWidget {
  final String chartOption;
  final Null Function(String option) setChartOption;

  TimeSeriesPills({this.chartOption, this.setChartOption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...TIME_SERIES_OPTIONS.entries
              .map((e) => FlatButton(
                    color: (e.key == chartOption)
                        ? Colors.orange.withAlpha(100)
                        : Colors.orange.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    onPressed: () {
                      this.setChartOption(e.key);
                    },
                    child: Text(e.value,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                  ))
              .toList()
        ],
      ),
    );
  }
}

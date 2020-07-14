import 'package:covid19india/core/constants/constants.dart';
import 'package:flutter/material.dart';

class TimeSeriesPills extends StatelessWidget {
  final TIME_SERIES_OPTIONS timeSeriesOption;
  final Null Function(TIME_SERIES_OPTIONS option) setTimeSeriesOption;

  TimeSeriesPills({this.timeSeriesOption, this.setTimeSeriesOption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...TIME_SERIES_OPTIONS_MAP.entries
              .map((e) => FlatButton(
                    color: (e.key == timeSeriesOption)
                        ? Colors.orange.withAlpha(100)
                        : Colors.orange.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    onPressed: () {
                      this.setTimeSeriesOption(e.key);
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

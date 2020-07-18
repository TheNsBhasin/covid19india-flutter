import 'package:covid19india/core/entity/time_series_option.dart';
import 'package:flutter/material.dart';

class TimeSeriesPills extends StatelessWidget {
  final TimeSeriesOption timeSeriesOption;
  final Null Function(TimeSeriesOption option) setTimeSeriesOption;

  TimeSeriesPills({this.timeSeriesOption, this.setTimeSeriesOption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...TimeSeriesOption.values
              .map((e) => FlatButton(
                    color: (e == timeSeriesOption)
                        ? Colors.orange.withAlpha(100)
                        : Colors.orange.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    onPressed: () {
                      this.setTimeSeriesOption(e);
                    },
                    child: Text(e.name,
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

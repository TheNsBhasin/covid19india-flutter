import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/time_series_line_chart.dart';
import 'package:flutter/material.dart';

class MiniGraph extends StatelessWidget {
  final List<TimeSeries> timeSeries;

  MiniGraph({this.timeSeries});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ...Constants.PRIMARY_STATISTICS
              .map((statistics) => TimeSeriesLineChart(
                  timeSeries: timeSeries, statistics: statistics))
              .toList()
        ],
      ),
    );
  }
}

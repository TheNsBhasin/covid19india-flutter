import 'dart:math';

import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/time_series/domain/entities/stats.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TimeSeriesLineChart extends StatelessWidget {
  final List<TimeSeries> timeSeries;
  final String statistics;

  const TimeSeriesLineChart({Key key, this.timeSeries, this.statistics})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: AspectRatio(
        aspectRatio: 1.70,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LineChart(mainData()),
          ),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(enabled: false),
      minX: 0,
      maxX: 100,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: _getData().map((e) => FlSpot(e[0], e[1])).toList(),
          isCurved: true,
          colors: [Constants.STATS_COLOR[this.statistics]],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
              show: true,
              checkToShowDot: (FlSpot spot, LineChartBarData barData) {
                return barData.spots.last == spot;
              }),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  List<List<double>> _getData() {
    int minDaily = _dailyMin();
    int maxDaily = _dailyMax();

    List<TimeSeries> data =
        _getLastNDaysData(Constants.MINIGRAPH_LOOKBACK_DAYS);

    return data
        .map((e) => [
              Utilities.scaleTime(data.first.date, data.last.date, e.date),
              Utilities.scaleLinear(
                  minDaily, maxDaily, _getStatistics(e.delta, this.statistics))
            ])
        .toList();
  }

  int _getStatistics(Stats data, statistics) {
    if (statistics == 'confirmed') {
      return data.confirmed;
    } else if (statistics == 'active') {
      return data.active;
    } else if (statistics == 'recovered') {
      return data.recovered;
    } else if (statistics == 'deceased') {
      return data.deceased;
    } else if (statistics == 'tested') {
      return data.tested;
    }

    return data.confirmed;
  }

  _getLastNDaysData(int cutoff) {
    timeSeries.sort((a, b) {
      return a.date.compareTo(b.date);
    });

    DateTime now = new DateTime.now();

    return timeSeries
        .where((e) =>
            now.difference(e.date).inDays <= cutoff &&
            now.difference(e.date).inDays > 1)
        .toList();
  }

  int _dailyMin() {
    int minCases = 1000000009;
    timeSeries.forEach((element) {
      minCases = min(minCases, element.delta.active);
    });

    return minCases;
  }

  int _dailyMax() {
    int maxCases = 0;
    timeSeries.forEach((element) {
      maxCases = max(maxCases, element.delta.confirmed);
      maxCases = max(maxCases, element.delta.recovered);
      maxCases = max(maxCases, element.delta.deceased);
    });

    return maxCases;
  }
}

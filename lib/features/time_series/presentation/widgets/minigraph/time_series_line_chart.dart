import 'dart:math';

import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grizzly_scales/grizzly_scales.dart';

class TimeSeriesLineChart extends StatelessWidget {
  final List<TimeSeries> timeSeries;
  final String statistics;
  final DateTime date;

  final double yBufferTop = 1.2;
  final double yBufferBottom = 1.1;

  const TimeSeriesLineChart(
      {Key key, this.timeSeries, this.statistics, this.date})
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
      minX: _getMinX(),
      maxX: _getMaxX(),
      minY: _getMinY(),
      maxY: _getMaxY(),
      lineBarsData: [
        LineChartBarData(
          spots: _getData().map((e) => FlSpot(e[0], e[1])).toList(),
          isCurved: true,
          colors: [STATS_COLOR[this.statistics]],
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
    List<TimeSeries> data = _getTimeSeries();

    Scale xScale = _getXScale();
    Scale yScale = _getYScale();

    return data
        .asMap()
        .entries
        .map((e) => <double>[
              xScale.scale(e.key).toDouble(),
              yScale.scale(
                  getStatisticValue(e.value.delta, statistics).toDouble())
            ])
        .toList();
  }

  List<TimeSeries> _getTimeSeries() {
    return _getLastNDaysData(MINIGRAPH_LOOKBACK_DAYS);
  }

  List<TimeSeries> _getLastNDaysData(int cutoff) {
    timeSeries.sort((a, b) {
      return a.date.compareTo(b.date);
    });

    List<TimeSeries> filteredTimeSeries = timeSeries
        .where((e) =>
            !e.date.isAfter(date) &&
            date.difference(e.date).inDays <= cutoff &&
            !e.date.isToday())
        .toList();

    return filteredTimeSeries;
  }

  Scale _getXScale() {
    return LinearScale([_getMinX(), _getMaxX()], [_getMinX(), _getMaxX()]);
  }

  Scale _getYScale() {
    double scaleMin = _uniformScaleMin().toDouble();
    double scaleMax = max(1, yBufferTop * _uniformScaleMax()).toDouble();

    return LinearScale([scaleMin, scaleMax], [_getMinY(), _getMaxY()]);
  }

  int _uniformScaleMin() {
    return min(
      min(_getMinStatistics('confirmed'), _getMinStatistics('active')),
      min(_getMinStatistics('recovered'), _getMinStatistics('deceased')),
    );
  }

  int _uniformScaleMax() {
    return max(
      max(_getMaxStatistics('confirmed'), _getMaxStatistics('active')),
      max(_getMaxStatistics('recovered'), _getMaxStatistics('deceased')),
    );
  }

  int _getMinStatistics(String statistics) {
    int minCases = 1000000009;
    _getTimeSeries().forEach((e) {
      minCases = min(minCases, getStatisticValue(e.delta, statistics));
    });

    return minCases;
  }

  int _getMaxStatistics(String statistics) {
    int maxCases = 1;
    _getTimeSeries().forEach((e) {
      maxCases = max(maxCases, getStatisticValue(e.delta, statistics));
    });

    return maxCases;
  }

  double _getMinX() {
    return 0.0;
  }

  double _getMaxX() {
    return _getTimeSeries().length.toDouble();
  }

  double _getMinY() {
    return 0.0;
  }

  double _getMaxY() {
    return 100.0;
  }
}

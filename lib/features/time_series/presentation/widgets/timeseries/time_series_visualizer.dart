import 'dart:math';

import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/features/time_series/domain/entities/stats.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:intl/intl.dart';

class TimeSeriesItem extends StatelessWidget {
  final List<TimeSeries> timeSeries;
  final String statistics;
  final String statisticsType;
  final String chartOption;
  final bool isUniform;
  final bool isLogarithmic;

  final double yBufferTop = 1.2;
  final double yBufferBottom = 1.1;

  final numTicksX = 4;

  TimeSeriesItem(
      {this.timeSeries,
      this.statistics,
      this.statisticsType,
      this.chartOption,
      this.isUniform,
      this.isLogarithmic});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: Container(
        decoration: BoxDecoration(
            color: Constants.STATS_COLOR[statistics].withAlpha(50),
            borderRadius: BorderRadius.all(new Radius.circular(5.0))),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statistics.capitalize(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Constants.STATS_COLOR[statistics]),
                ),
                Text(
                  new DateFormat('d MMMM')
                      .format(timeSeries.last.date.toLocal()),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Constants.STATS_COLOR[statistics]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      NumberFormat.decimalPattern('en_IN').format(
                          _getStatistics(
                              timeSeries.last.total, statistics)),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Constants.STATS_COLOR[statistics]),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                        _getStatistics(
                                    timeSeries.last.delta, statistics) >
                                0
                            ? "+" +
                                NumberFormat.decimalPattern('en_IN')
                                    .format(_getStatistics(
                                        timeSeries.last.delta,
                                        statistics))
                            : "",
                        style: TextStyle(
                            fontSize: 12,
                            color: Constants.STATS_COLOR[statistics])),
                  ],
                ),
              ],
            ),
          ),
          _buildLineChart(),
        ]),
      ),
    );
  }

  Widget _buildLineChart() {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: LineChart(
            _getChartData(),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        ),
      ),
    );
  }

  LineChartData _getChartData() {
    DateTime startTime = _getTimeSeries().first.date;

    Scale xScale = _getXScale();
    Scale yScale = _getYScale();

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 4,
          textStyle: TextStyle(
            color: Constants.STATS_COLOR[statistics],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 12,
          interval: _getIntervalX(),
          getTitles: (value) {
            try {
              return new DateFormat('d MMMM').format(startTime
                  .add(Duration(days: xScale.invert(value).toInt()))
                  .toLocal());
            } catch (e) {}

            return '';
          },
        ),
        leftTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Constants.STATS_COLOR[statistics],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          interval: _getIntervalY(),
          getTitles: (value) {
            try {
              return new NumberFormat.compact().format(yScale.invert(value));
            } catch (e) {}

            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border(
              bottom: BorderSide(
                  color: Constants.STATS_COLOR[statistics], width: 2),
              right: BorderSide(
                  color: Constants.STATS_COLOR[statistics], width: 2))),
      lineTouchData: LineTouchData(enabled: false),
      minX: _getMinX(),
      maxX: _getMaxX(),
      minY: _getMinY(),
      maxY: _getMaxY(),
      lineBarsData: [
        LineChartBarData(
          spots: _getData().map((e) => FlSpot(e[0], e[1])).toList(),
          isCurved: true,
          colors: [Constants.STATS_COLOR[this.statistics]],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: chartOption != 'BEGINNING'),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  List<List<double>> _getData() {
    List<TimeSeries> data = _getTimeSeries();

    DateTime startTime = data.first.date;

    Scale xScale = _getXScale();
    Scale yScale = _getYScale();

    return data
        .map((e) => <double>[
              xScale.scale(e.date.difference(startTime).inDays).toDouble(),
              yScale.scale(isLogarithmic
                  ? max(
                      1.0,
                      _getStatistics(
                              statisticsType == 'total' ? e.total : e.delta,
                              statistics)
                          .toDouble())
                  : _getStatistics(
                          statisticsType == 'total' ? e.total : e.delta,
                          statistics)
                      .toDouble())
            ])
        .toList();
  }

  List<TimeSeries> _getTimeSeries() {
    timeSeries.sort((a, b) {
      return a.date.compareTo(b.date);
    });

    if (chartOption == 'MONTH') {
      return _getLastNDaysData(30);
    } else if (chartOption == 'TWO_WEEKS') {
      return _getLastNDaysData(14);
    }

    return timeSeries.toList();
  }

  double _getMinX() {
    return 0.0;
  }

  double _getMaxX() {
    DateTime startTime = _getTimeSeries().first.date;
    DateTime endTime = _getTimeSeries().last.date;

    return endTime.difference(startTime).inDays.toDouble();
  }

  double _getMinY() {
    return 0.0;
  }

  double _getMaxY() {
    return 100.0;
  }

  double _getIntervalX() {
    return (_getMaxX() - _getMinX()) / 4;
  }

  double _getIntervalY() {
    return (_getMaxY() - _getMinY()) / 5;
  }

  List<TimeSeries> _getLastNDaysData(int cutoff) {
    DateTime now = new DateTime.now();

    return timeSeries
        .where((e) =>
            now.difference(e.date).inDays <= cutoff &&
            now.difference(e.date).inDays > 1)
        .toList();
  }

  Scale _getXScale() {
    return LinearScale([_getMinX(), _getMaxX()], [_getMinX(), _getMaxX()]);
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

  Scale _yScaleUniformLinear() {
    double scaleMin = _uniformScaleMin().toDouble();
    double scaleMax = max(1, yBufferTop * _uniformScaleMax()).toDouble();

    return LinearScale([scaleMin, scaleMax], [_getMinY(), _getMaxY()]);
  }

  Scale _yScaleUniformLog() {
    double scaleMin = max(1, _uniformScaleMin()).toDouble();
    double scaleMax = max(10, yBufferTop * _uniformScaleMax()).toDouble();

    return LogScale([scaleMin, scaleMax], [_getMinY(), _getMaxY()]);
  }

  _getYScale() {
    if (isUniform &&
        statisticsType == 'total' &&
        isLogarithmic &&
        statistics != 'tested') {
      return _yScaleUniformLog();
    }

    if (isUniform && statistics != 'tested') {
      return _yScaleUniformLinear();
    }

    if (statisticsType == 'total' && isLogarithmic) {
      double scaleMin = max(1, _getMinStatistics(statistics)).toDouble();
      double scaleMax =
          max(10, yBufferTop * _getMaxStatistics(statistics)).toDouble();

      return LogScale([scaleMin, scaleMax], [_getMinY(), _getMaxY()]);
    }

    double scaleMin =
        min(0, yBufferBottom * _getMinStatistics(statistics)).toDouble();
    double scaleMax =
        max(1, yBufferTop * _getMaxStatistics(statistics)).toDouble();

    return LinearScale([scaleMin, scaleMax], [_getMinY(), _getMaxY()]);
  }

  int _getMinStatistics(String statistics) {
    int minCases = 1000000009;
    _getTimeSeries().forEach((e) {
      minCases = min(
          minCases,
          _getStatistics(
              statisticsType == 'total' ? e.total : e.delta, statistics));
    });

    return minCases;
  }

  int _getMaxStatistics(String statistics) {
    int maxCases = 1;
    _getTimeSeries().forEach((e) {
      maxCases = max(
          maxCases,
          _getStatistics(
              statisticsType == 'total' ? e.total : e.delta, statistics));
    });

    return maxCases;
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
}

class TimeSeriesVisualizer extends StatefulWidget {
  final List<TimeSeries> timeSeries;
  final String statisticsType;
  final String stateCode;
  final String chartOption;
  final bool isUniform;
  final bool isLogarithmic;

  TimeSeriesVisualizer(
      {this.timeSeries,
      this.statisticsType,
      this.stateCode,
      this.chartOption,
      this.isUniform,
      this.isLogarithmic});

  @override
  _TimeSeriesVisualizerState createState() => _TimeSeriesVisualizerState();
}

class _TimeSeriesVisualizerState extends State<TimeSeriesVisualizer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...Constants.TIME_SERIES_STATISTICS
              .map((statistics) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: TimeSeriesItem(
                      timeSeries: widget.timeSeries,
                      statistics: statistics,
                      statisticsType: widget.statisticsType,
                      chartOption: widget.chartOption,
                      isUniform: widget.isUniform,
                      isLogarithmic: widget.isLogarithmic,
                    ),
                  ))
              .toList()
        ],
      ),
    );
  }
}

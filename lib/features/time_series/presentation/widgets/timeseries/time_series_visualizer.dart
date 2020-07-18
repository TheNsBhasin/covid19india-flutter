import 'dart:math';

import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/statistic.dart';
import 'package:covid19india/core/entity/time_series_chart_type.dart';
import 'package:covid19india/core/entity/time_series_option.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grizzly_range/grizzly_range.dart' as ranger;
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:intl/intl.dart';

class TimeSeriesItem extends StatelessWidget {
  final List<TimeSeries> timeSeries;

  final Statistic statistic;

  final TimeSeriesOption timeSeriesOption;
  final TimeSeriesChartType chartType;

  final bool isUniform;
  final bool isLog;

  TimeSeriesItem(
      {this.timeSeries,
      this.statistic,
      this.timeSeriesOption,
      this.chartType,
      this.isUniform,
      this.isLog});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: Container(
        decoration: BoxDecoration(
            color: STATS_COLOR[statistic].withAlpha(50),
            borderRadius: BorderRadius.all(new Radius.circular(5.0))),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statistic.name.capitalize(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: STATS_COLOR[statistic]),
                ),
                Text(
                  new DateFormat('d MMMM')
                      .format(timeSeries.last.date.toLocal()),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: STATS_COLOR[statistic]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      NumberFormat.decimalPattern('en_IN').format(
                          getStatisticValue(timeSeries.last.total, statistic)),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: STATS_COLOR[statistic]),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                        getStatisticValue(timeSeries.last.delta, statistic) > 0
                            ? "+" +
                                NumberFormat.decimalPattern('en_IN').format(
                                    getStatisticValue(
                                        timeSeries.last.delta, statistic))
                            : "",
                        style: TextStyle(
                            fontSize: 12, color: STATS_COLOR[statistic])),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 32.0),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return _buildChart(context, constraints.maxWidth);
            }),
          ),
        ]),
      ),
    );
  }

  Widget _buildChart(BuildContext context, double maxWidth) {
    final numDates = timeSeries.length;

    final double barWidth =
        timeSeriesOption == TimeSeriesOption.beginning ? 2 : 6;

    final double spacing = (maxWidth - 72 - numDates * barWidth) / numDates;

    final double minX = 0;
    final double maxX = timeSeries.length.toDouble();

    final Scale xScale = LinearScale(
      <double>[minX, maxX],
      <double>[minX, maxX],
    );

    final int xNumTicks = 5;

    final List<num> xTicks = xScale.ticks(count: xNumTicks).toList();

    final double xInterval =
        (xScale.scale(xTicks[1]) - xScale.scale(xTicks[0])).toDouble();

    final Scale yScale =
        _getYScale(timeSeries, statistic, chartType, isUniform, isLog);

    final double minValue =
        isLog ? min(1, yScale.domain.first) : min(0, yScale.domain.first);
    final double maxValue = yScale.domain.last;

    final int yNumTicks = maxValue - minValue > 6 ? 6 : 0;

    final List<num> yTicks = yNumTicks > 0
        ? ranger.ticks(minValue, maxValue, yNumTicks).toList()
        : [0, 1];

    final double yInterval = (yTicks[1] - yTicks[0]).toDouble();

    final double minY = min(yTicks.first.toDouble(), minValue);
    final double maxY = max(yTicks.last.toDouble(), maxValue);

    if (chartType == TimeSeriesChartType.total) {
      return Container(
        child: AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: LineChart(
              LineChartData(
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY,
                lineTouchData: LineTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: SideTitles(showTitles: false),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    textStyle: TextStyle(
                        color: STATS_COLOR[statistic],
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                    margin: 10,
                    rotateAngle: 0,
                    getTitles: (double value) {
                      try {
                        if (value == 0 ||
                            value % xInterval == 0 ||
                            value == numDates - 1) {
                          return DateFormat("dd MMM").format(timeSeries[xScale
                                  .clamper()
                                  (xScale.invert(xScale.clamper()(value)))
                                  .toInt()]
                              .date);
                        }
                      } catch (e) {}

                      return "";
                    },
                  ),
                  leftTitles: SideTitles(showTitles: false),
                  rightTitles: SideTitles(
                    showTitles: true,
                    textStyle: TextStyle(
                        color: STATS_COLOR[statistic],
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                    margin: 10,
                    rotateAngle: 0,
                    interval: yInterval,
                    getTitles: (double value) {
                      try {
                        return NumberFormat.compact().format(value.toInt());
                      } catch (e) {}

                      return "";
                    },
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                      bottom:
                          BorderSide(color: STATS_COLOR[statistic], width: 2),
                      right:
                          BorderSide(color: STATS_COLOR[statistic], width: 2)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: <FlSpot>[
                      ...timeSeries.asMap().entries.map((e) {
                        final double x = e.key.toDouble();
                        final double y = chartType == TimeSeriesChartType.total
                            ? yScale.scale(yScale.clamper()(
                                getStatisticValue(e.value.total, statistic)
                                    .toDouble()))
                            : yScale.scale(yScale.clamper()(
                                getStatisticValue(e.value.delta, statistic)
                                    .toDouble()));

                        return FlSpot(x, y);
                      }),
                    ],
                    isCurved: true,
                    colors: [STATS_COLOR[this.statistic]],
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                        show: timeSeriesOption != TimeSeriesOption.beginning),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      child: AspectRatio(
        aspectRatio: 1.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              minY: minY,
              maxY: maxY,
              groupsSpace: spacing,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  textStyle: TextStyle(
                      color: STATS_COLOR[statistic],
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                  margin: 10,
                  rotateAngle: 0,
                  getTitles: (double value) {
                    try {
                      if (value == 0 ||
                          value % xInterval == 0 ||
                          value == numDates - 1) {
                        return DateFormat("dd MMM").format(timeSeries[xScale
                                .clamper()
                                (xScale.invert(xScale.clamper()(value)))
                                .toInt()]
                            .date);
                      }
                    } catch (e) {}

                    return "";
                  },
                ),
                leftTitles: SideTitles(showTitles: false),
                rightTitles: SideTitles(
                  showTitles: true,
                  textStyle: TextStyle(
                      color: STATS_COLOR[statistic],
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                  margin: 18,
                  rotateAngle: 0,
                  interval: yInterval,
                  getTitles: (double value) {
                    try {
                      return NumberFormat.compact().format(value.toInt());
                    } catch (e) {}

                    return "";
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value == 0,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: STATS_COLOR[statistic],
                    strokeWidth: 0.2,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                    bottom: BorderSide(color: STATS_COLOR[statistic], width: 2),
                    right: BorderSide(color: STATS_COLOR[statistic], width: 2)),
              ),
              barGroups: [
                ...timeSeries.asMap().entries.map((e) {
                  final int x = e.key;

                  final double y = chartType == TimeSeriesChartType.total
                      ? yScale.scale(yScale.clamper()(
                          getStatisticValue(e.value.total, statistic)
                              .toDouble()))
                      : yScale.scale(yScale.clamper()(
                          getStatisticValue(e.value.delta, statistic)
                              .toDouble()));

                  return BarChartGroupData(
                    x: x,
                    barRods: [
                      BarChartRodData(
                        y: y,
                        color: x == timeSeries.length - 1
                            ? STATS_COLOR[statistic]
                            : STATS_COLOR[statistic].withOpacity(0.50),
                        width: barWidth,
                        borderRadius: BorderRadius.only(
                          topLeft:
                              y > 0 ? Radius.circular(6) : Radius.circular(0),
                          topRight:
                              y > 0 ? Radius.circular(6) : Radius.circular(0),
                          bottomLeft:
                              y < 0 ? Radius.circular(6) : Radius.circular(0),
                          bottomRight:
                              y < 0 ? Radius.circular(6) : Radius.circular(0),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Scale _getYScale(List<TimeSeries> timeSeries, Statistic statistic,
      TimeSeriesChartType chartType, bool isUniform, bool isLog) {
    if (isUniform &&
        chartType == TimeSeriesChartType.total &&
        isLog &&
        statistic != Statistic.tested) {
      return yScaleUniformLog(timeSeries, chartType);
    }

    if (isUniform && statistic != Statistic.tested) {
      return yScaleUniformLinear(timeSeries, chartType);
    }

    int minStats = _getMinStatistics(timeSeries, chartType, statistic);
    int maxStats = _getMaxStatistics(timeSeries, chartType, statistic);

    if (chartType == TimeSeriesChartType.total && isLog) {
      return LogScale(<double>[
        max(1, minStats).toDouble(),
        max(10, maxStats).toDouble()
      ], <double>[
        max(1, minStats).toDouble(),
        max(10, maxStats).toDouble()
      ]).nice();
    }

    return LinearScale(<double>[
      min(0, minStats).toDouble(),
      max(1, maxStats).toDouble()
    ], <double>[
      min(0, minStats).toDouble(),
      max(1, maxStats).toDouble()
    ]).nice(count: 4);
  }

  Scale yScaleUniformLog(
      List<TimeSeries> timeSeries, TimeSeriesChartType chartType) {
    int minStats = _uniformScaleMin(timeSeries, chartType);
    int maxStats = _uniformScaleMax(timeSeries, chartType);

    return LogScale(<double>[
      max(1, minStats).toDouble(),
      max(10, maxStats).toDouble()
    ], <double>[
      max(1, minStats).toDouble(),
      max(10, maxStats).toDouble()
    ]).nice();
  }

  Scale yScaleUniformLinear(
      List<TimeSeries> timeSeries, TimeSeriesChartType chartType) {
    int minStats = _uniformScaleMin(timeSeries, chartType);
    int maxStats = _uniformScaleMax(timeSeries, chartType);

    return LinearScale(<double>[
      minStats.toDouble(),
      max(1, maxStats).toDouble()
    ], <double>[
      minStats.toDouble(),
      max(1, maxStats).toDouble()
    ]).nice(count: 4);
  }

  int _uniformScaleMin(
      List<TimeSeries> timeSeries, TimeSeriesChartType chartType) {
    return min(
      min(_getMinStatistics(timeSeries, chartType, Statistic.confirmed),
          _getMinStatistics(timeSeries, chartType, Statistic.active)),
      min(_getMinStatistics(timeSeries, chartType, Statistic.recovered),
          _getMinStatistics(timeSeries, chartType, Statistic.deceased)),
    );
  }

  int _uniformScaleMax(
      List<TimeSeries> timeSeries, TimeSeriesChartType chartType) {
    return max(
      max(_getMaxStatistics(timeSeries, chartType, Statistic.confirmed),
          _getMaxStatistics(timeSeries, chartType, Statistic.active)),
      max(_getMaxStatistics(timeSeries, chartType, Statistic.recovered),
          _getMaxStatistics(timeSeries, chartType, Statistic.deceased)),
    );
  }

  int _getMinStatistics(List<TimeSeries> timeSeries,
      TimeSeriesChartType chartType, Statistic statistic) {
    return timeSeries
        .map((e) => getStatisticValue(
            chartType == TimeSeriesChartType.total ? e.total : e.delta,
            statistic))
        .reduce(min);
  }

  int _getMaxStatistics(List<TimeSeries> timeSeries,
      TimeSeriesChartType chartType, Statistic statistic) {
    return timeSeries
        .map((e) => getStatisticValue(
            chartType == TimeSeriesChartType.total ? e.total : e.delta,
            statistic))
        .reduce(max);
  }
}

class TimeSeriesVisualizer extends StatelessWidget {
  final List<TimeSeries> timeSeries;

  final DateTime timelineDate;

  final TimeSeriesOption timeSeriesOption;
  final TimeSeriesChartType chartType;

  final bool isUniform;
  final bool isLog;

  TimeSeriesVisualizer(
      {this.timeSeries,
      this.timelineDate,
      this.timeSeriesOption,
      this.chartType,
      this.isUniform,
      this.isLog});

  @override
  Widget build(BuildContext context) {
    List<TimeSeries> filteredTimeSeries =
        _getFilteredTimeSeries(timeSeries, timelineDate, timeSeriesOption);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...TIME_SERIES_STATISTICS
              .map((statistic) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: TimeSeriesItem(
                      timeSeries: filteredTimeSeries,
                      statistic: statistic,
                      chartType: chartType,
                      timeSeriesOption: timeSeriesOption,
                      isUniform: isUniform,
                      isLog: isLog,
                    ),
                  ))
              .toList()
        ],
      ),
    );
  }

  List<TimeSeries> _getFilteredTimeSeries(List<TimeSeries> timeSeries,
      DateTime timelineDate, TimeSeriesOption timeSeriesOption) {
    final List<TimeSeries> sortedTimeSeries = timeSeries
      ..sort((a, b) => a.date.compareTo(b.date))
      ..toList();

    final DateTime today = timelineDate.isToday()
        ? timelineDate.subtract(Duration(days: 1))
        : timelineDate;

    List<TimeSeries> filteredTimeSeries =
        sortedTimeSeries.where((e) => !e.date.isAfter(today)).toList();

    if (timeSeriesOption == TimeSeriesOption.month) {
      DateTime cuttOffDate = today.subtract(Duration(days: 30));

      return filteredTimeSeries
          .where((e) => !e.date.isBefore(cuttOffDate))
          .toList();
    } else if (timeSeriesOption == TimeSeriesOption.two_weeks) {
      DateTime cuttOffDate = today.subtract(Duration(days: 14));

      return filteredTimeSeries
          .where((e) => !e.date.isBefore(cuttOffDate))
          .toList();
    }

    return filteredTimeSeries;
  }
}

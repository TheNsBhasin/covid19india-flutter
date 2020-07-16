import 'dart:math';

import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:intl/intl.dart';

class DeltaBarGraph extends StatefulWidget {
  final StateWiseTimeSeries timeSeries;

  final String stateCode;
  final STATISTIC statistic;

  DeltaBarGraph({this.timeSeries, this.stateCode, this.statistic});

  @override
  _DeltaBarGraphState createState() => _DeltaBarGraphState();
}

class _DeltaBarGraphState extends State<DeltaBarGraph> {
  int lookback;

  @override
  void initState() {
    super.initState();

    lookback = 6;
  }

  @override
  Widget build(BuildContext context) {
    List<TimeSeries> filteredTimeSeries =
        _getLastTimeSeres(lookback).reversed.toList();

    int minDeltaStats = 0;
    int maxDeltaStats = 1;

    filteredTimeSeries.forEach((e) {
      minDeltaStats =
          min(minDeltaStats, getStatisticValue(e.delta, widget.statistic));
      maxDeltaStats =
          max(maxDeltaStats, getStatisticValue(e.delta, widget.statistic));
    });

    final double minY = (minDeltaStats < 0 ? -50 : 0).toDouble();
    final double maxY = (maxDeltaStats < 50 ? maxDeltaStats : 50).toDouble();

    final Scale yScale =
        LinearScale([minDeltaStats, maxDeltaStats], [minY, maxY]);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final double spacing = lookback < 7 ? 32 : 24;

      final double barWidth =
          (constraints.maxWidth - lookback * spacing - 32) / lookback;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1.7,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.center,
                  maxY: maxY + 8,
                  minY: minY < 0 ? minY - 28 : minY,
                  groupsSpace: spacing,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      tooltipPadding: const EdgeInsets.all(0),
                      tooltipBottomMargin: 8,
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        final int delta = getStatisticValue(
                            filteredTimeSeries[groupIndex].delta,
                            widget.statistic);

                        String text1 =
                            NumberFormat.decimalPattern('en_IN').format(delta);

                        String text2 = "";

                        if (groupIndex > 0) {
                          final int prevValue = getStatisticValue(
                              filteredTimeSeries[groupIndex - 1].delta,
                              widget.statistic);

                          final int increase = delta - prevValue;

                          text2 =
                              "${increase > 0 ? "+" : ""}${NumberFormat.decimalPattern('en_IN').format(double.parse(((100 * increase) / prevValue.abs()).toStringAsFixed(2)))}%";
                        }

                        String text = (groupIndex == 0)
                            ? text1
                            : (delta > 0
                                ? text2 + "\n" + text1
                                : text1 + "\n" + text2);

                        return BarTooltipItem(
                          text,
                          TextStyle(
                            fontSize: 10,
                            color: STATS_COLOR[widget.statistic],
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      textStyle: TextStyle(
                          color: STATS_COLOR[widget.statistic],
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                      margin: 10,
                      rotateAngle: 0,
                      getTitles: (double value) {
                        return DateFormat("dd MMM")
                            .format(filteredTimeSeries[value.toInt()].date);
                      },
                    ),
                    leftTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    ...filteredTimeSeries.asMap().entries.map((e) {
                      final int x = e.key;
                      final double y = yScale.scale(
                          getStatisticValue(e.value.delta, widget.statistic));

                      return BarChartGroupData(
                        x: x,
                        barRods: [
                          BarChartRodData(
                            y: y,
                            color: x == filteredTimeSeries.length - 1
                                ? STATS_COLOR[widget.statistic]
                                : STATS_COLOR[widget.statistic]
                                    .withOpacity(0.50),
                            width: barWidth,
                            borderRadius: BorderRadius.only(
                              topLeft: y > 0
                                  ? Radius.circular(6)
                                  : Radius.circular(0),
                              topRight: y > 0
                                  ? Radius.circular(6)
                                  : Radius.circular(0),
                              bottomLeft: y < 0
                                  ? Radius.circular(6)
                                  : Radius.circular(0),
                              bottomRight: y < 0
                                  ? Radius.circular(6)
                                  : Radius.circular(0),
                            ),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlatButton.icon(
                  onPressed: () => {
                        setState(() {
                          lookback = (lookback == 6) ? 10 : 6;
                        })
                      },
                  icon: FaIcon(
                    lookback == 10
                        ? FontAwesomeIcons.arrowRight
                        : FontAwesomeIcons.arrowLeft,
                    color: Colors.grey,
                    size: 14,
                  ),
                  label: Text(
                    lookback == 10 ? "View less" : "View more",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  )),
            ],
          ),
        ],
      );
    });
  }

  List<TimeSeries> _getLastTimeSeres(int lookback) {
    final List<TimeSeries> sortedTimeSeries = widget.timeSeries.timeSeries
      ..sort((a, b) => b.date.compareTo(a.date));

    return sortedTimeSeries
        .where((e) => !e.date.isToday())
        .toList()
        .sublist(0, min(lookback, sortedTimeSeries.length))
        .toList();
  }
}

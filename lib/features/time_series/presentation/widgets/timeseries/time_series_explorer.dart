import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_alerts.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_header.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_pills.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_visualizer.dart';
import 'package:flutter/material.dart';

class TimeSeriesExplorer extends StatefulWidget {
  final Map<String, List<TimeSeries>> timeSeriesMap;
  final DateTime date;

  TimeSeriesExplorer({this.timeSeriesMap, this.date});

  @override
  _TimeSeriesExplorerState createState() => _TimeSeriesExplorerState();
}

class _TimeSeriesExplorerState extends State<TimeSeriesExplorer> {
  String statisticsType;
  String stateCode;
  String chartOption;
  bool isUniform;
  bool isLogarithmic;

  @override
  void initState() {
    super.initState();

    statisticsType = 'delta';
    stateCode = 'TT';
    chartOption = 'MONTH';
    isUniform = true;
    isLogarithmic = false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TimeSeriesHeader(
              statisticsType: statisticsType,
              stateCode: stateCode,
              isUniform: isUniform,
              isLogarithmic: isLogarithmic,
              setStatisticsType: (statisticsType) {
                setState(() {
                  this.statisticsType = statisticsType;
                });
              },
              setStateCode: (stateCode) {
                setState(() {
                  this.stateCode = stateCode;
                });
              },
              setUniform: (value) {
                setState(() {
                  this.isUniform = value;
                });
              },
              setLogarithmic: (value) {
                setState(() {
                  this.isLogarithmic = value;
                });
              },
            ),
            TimeSeriesVisualizer(
                timeSeries: widget.timeSeriesMap[stateCode],
                date: widget.date,
                stateCode: stateCode,
                statisticsType: statisticsType,
                chartOption: chartOption,
                isUniform: isUniform,
                isLogarithmic: isLogarithmic),
            TimeSeriesPills(
              chartOption: chartOption,
              setChartOption: (String option) {
                setState(() {
                  chartOption = option;
                });
              },
            ),
            TimeSeriesAlerts(),
          ],
        ),
      ),
    );
  }
}

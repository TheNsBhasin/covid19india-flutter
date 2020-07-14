import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_alerts.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_pills.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_visualizer.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_header.dart';
import 'package:flutter/material.dart';

class TimeSeriesExplorer extends StatefulWidget {
  final Map<String, StateWiseTimeSeries> timeSeries;
  final String stateCode;
  final DateTime timelineDate;
  final Region regionHighlighted;
  final Function(Region regionHighlighted) setRegionHighlighted;

  TimeSeriesExplorer(
      {this.timeSeries,
      this.stateCode,
      this.timelineDate,
      this.regionHighlighted,
      this.setRegionHighlighted});

  @override
  _TimeSeriesExplorerState createState() => _TimeSeriesExplorerState();
}

class _TimeSeriesExplorerState extends State<TimeSeriesExplorer> {
  TIME_SERIES_OPTIONS timeSeriesOption;
  TIME_SERIES_CHART_TYPES chartType;

  bool isUniform;
  bool isLog;

  @override
  void initState() {
    super.initState();

    timeSeriesOption = TIME_SERIES_OPTIONS.TWO_WEEKS;
    chartType = TIME_SERIES_CHART_TYPES.TOTAL;

    isUniform = true;
    isLog = false;
  }

  @override
  Widget build(BuildContext context) {
    List<Region> regions = _getRegions(widget.timeSeries, widget.stateCode);

    Region selectedRegion =
        _getSelectedRegion(widget.timeSeries, widget.regionHighlighted);
    List<TimeSeries> selectedTimeSeries =
        _getSelectedTimeSeries(widget.timeSeries, selectedRegion);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TimeSeriesHeader(
              chartType: chartType,
              isUniform: isUniform,
              isLog: isLog,
              selectedRegion: selectedRegion,
              regions: regions,
              setChartType: (TIME_SERIES_CHART_TYPES newChartType) {
                setState(() {
                  this.chartType = newChartType;
                });
              },
              setUniform: (bool newIsUniform) {
                setState(() {
                  this.isUniform = newIsUniform;
                });
              },
              setLog: (bool newIsLog) {
                setState(() {
                  this.isLog = newIsLog;
                });
              },
              setRegionHighlighted: widget.setRegionHighlighted,
            ),
            TimeSeriesVisualizer(
              timeSeries: selectedTimeSeries,
              timelineDate: widget.timelineDate,
              timeSeriesOption: timeSeriesOption,
              chartType: chartType,
              isUniform: isUniform,
              isLog: isLog,
            ),
            TimeSeriesPills(
              timeSeriesOption: timeSeriesOption,
              setTimeSeriesOption: (TIME_SERIES_OPTIONS option) {
                setState(() {
                  timeSeriesOption = option;
                });
              },
            ),
            TimeSeriesAlerts()
          ],
        ),
      ),
    );
  }

  List<Region> _getRegions(
      Map<String, StateWiseTimeSeries> timeSeries, String stateCode) {
    List<Region> states = timeSeries.entries
        .where((stateData) => stateData.value.name != stateCode)
        .map((stateData) => new Region(
              stateCode: stateData.value.name,
              districtName: null,
            ))
        .toList();

    List<Region> districts = List<Region>();
    timeSeries.forEach((stateCode, stateData) {
      districts.addAll(stateData.districts.map((districtData) => new Region(
            stateCode: stateCode,
            districtName: districtData.name,
          )));
    });

    return <Region>[
      new Region(
        stateCode: stateCode,
        districtName: null,
      ),
      ...states,
      ...districts,
    ];
  }

  Region _getSelectedRegion(
      Map<String, StateWiseTimeSeries> timeSeries, Region regionHighlighted) {
    if (timeSeries[regionHighlighted.stateCode].districts != null &&
        timeSeries[regionHighlighted.stateCode]
                .districts
                .where((districtData) =>
                    districtData.name == regionHighlighted.districtName)
                .length >
            0) {
      return regionHighlighted;
    } else {
      return new Region(
        stateCode: regionHighlighted.stateCode,
        districtName: null,
      );
    }
  }

  List<TimeSeries> _getSelectedTimeSeries(
      Map<String, StateWiseTimeSeries> timeSeries, Region selectedRegion) {
    if (selectedRegion.districtName != null) {
      return timeSeries[selectedRegion.stateCode]
          .districts
          .where((districtData) =>
              districtData.name == selectedRegion.districtName)
          .first
          .timeSeries;
    } else {
      return timeSeries[selectedRegion.stateCode].timeSeries;
    }
  }
}

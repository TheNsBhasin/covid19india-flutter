import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_alerts.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_header.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_pills.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_visualizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSeriesExplorer extends StatelessWidget {
  final Map<MapCodes, StateTimeSeries> timeSeries;
  final MapCodes stateCode;

  TimeSeriesExplorer({
    this.timeSeries,
    this.stateCode,
  });

  @override
  Widget build(BuildContext context) {
    List<Region> regions = _getRegions(timeSeries, stateCode);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<RegionHighlightedBloc, Region>(
            builder: (context, regionHighlighted) {
          Region selectedRegion =
              _getSelectedRegion(timeSeries, regionHighlighted);
          List<TimeSeries> selectedTimeSeries =
              _getSelectedTimeSeries(timeSeries, selectedRegion);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TimeSeriesHeader(
                selectedRegion: selectedRegion,
                regions: regions,
                setRegionHighlighted: (Region regionHighlighted) {
                  context.bloc<RegionHighlightedBloc>().add(
                      RegionHighlightedChanged(
                          regionHighlighted: regionHighlighted));
                },
              ),
              TimeSeriesVisualizer(
                timeSeries: selectedTimeSeries,
              ),
              TimeSeriesPills(),
              TimeSeriesAlerts()
            ],
          );
        }),
      ),
    );
  }

  List<Region> _getRegions(
      Map<MapCodes, StateTimeSeries> timeSeries, MapCodes stateCode) {
    List<Region> states = timeSeries.entries
        .where((stateData) => stateData.value.stateCode != stateCode)
        .map((stateData) => Region(
              stateCode: stateData.value.stateCode,
              districtName: null,
            ))
        .toList();

    List<Region> districts = List<Region>();
    timeSeries.forEach((stateCode, stateData) {
      districts.addAll(stateData.districts.map((districtData) => Region(
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
      Map<MapCodes, StateTimeSeries> timeSeries, Region regionHighlighted) {
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
      Map<MapCodes, StateTimeSeries> timeSeries, Region selectedRegion) {
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

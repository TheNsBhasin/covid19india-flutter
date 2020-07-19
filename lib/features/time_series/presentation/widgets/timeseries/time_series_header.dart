import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/core/entity/time_series_chart_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSeriesHeader extends StatelessWidget {
  final Region selectedRegion;
  final List<Region> regions;

  final Function(Region regionHighlighted) setRegionHighlighted;

  TimeSeriesHeader(
      {this.regions, this.selectedRegion, this.setRegionHighlighted});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpreadTrendTitle(),
          SizedBox(
            height: 8.0,
          ),
          StatisticsTypeSelector(),
          SizedBox(
            height: 8.0,
          ),
          ScaleModeSelector(),
          SizedBox(height: 8.0),
          RegionDropdown(
            regions: regions,
            selectedRegion: selectedRegion,
            onChange: setRegionHighlighted,
          ),
        ],
      ),
    );
  }
}

class ScaleModeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeSeriesChartBloc, TimeSeriesChartState>(
      buildWhen: (previous, current) =>
          previous.isLog != current.isLog ||
          previous.isUniform != current.isUniform ||
          previous.chartType != current.chartType,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Scale Modes",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Uniform",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                    Switch(
                      value: state.isUniform,
                      activeColor: Colors.grey,
                      onChanged: (bool value) {
                        context.bloc<TimeSeriesChartBloc>().add(
                            TimeSeriesChartScaleChanged(
                                isLog: state.isLog, isUniform: value));
                      },
                    ),
                  ],
                ),
                if (state.chartType == TimeSeriesChartType.total)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Logarithmic",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                      Switch(
                        value: state.isLog,
                        activeColor: Colors.grey,
                        onChanged: (bool value) {
                          context.bloc<TimeSeriesChartBloc>().add(
                              TimeSeriesChartScaleChanged(
                                  isLog: value, isUniform: state.isUniform));
                        },
                      ),
                    ],
                  )
              ],
            )
          ],
        );
      },
    );
  }
}

class StatisticsTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeSeriesChartBloc, TimeSeriesChartState>(
      buildWhen: (previous, current) => previous.chartType != current.chartType,
      builder: (context, state) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: TimeSeriesChartType.values
                .map((e) => FlatButton(
                      color: (e == state.chartType)
                          ? Colors.orange.withAlpha(100)
                          : Colors.orange.withAlpha(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0)),
                      onPressed: () {
                        context
                            .bloc<TimeSeriesChartBloc>()
                            .add(TimeSeriesChartTypeChanged(chartType: e));
                      },
                      child: Text(e.name,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                    ))
                .toList());
      },
    );
  }
}

class SpreadTrendTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Text(
          'Spread Trends',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }
}

class RegionDropdown extends StatelessWidget {
  final List<Region> regions;
  final Region selectedRegion;

  final void Function(Region region) onChange;

  RegionDropdown({this.regions, this.selectedRegion, this.onChange});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Region>(
        value: selectedRegion,
        onChanged: onChange,
        isExpanded: true,
        items: regions.map((region) {
          return DropdownMenuItem<Region>(
            value: region,
            child: Text(
                region.districtName != null
                    ? region.districtName
                    : region.stateCode.name,
                softWrap: true,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          );
        }).toList(),
      ),
    );
  }
}

import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/state_time_series/bloc.dart'
    as StateTimeSeriesBloc;
import 'package:covid19india/features/time_series/presentation/bloc/time_series/bloc.dart'
    as CountryTimeSeriesBloc;
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSeriesExplorerWidget extends StatelessWidget {
  final String stateCode;
  final DateTime timelineDate;
  final Region regionHighlighted;
  final Function(Region regionHighlighted) setRegionHighlighted;

  TimeSeriesExplorerWidget(
      {this.stateCode,
      this.timelineDate,
      this.regionHighlighted,
      this.setRegionHighlighted});

  @override
  Widget build(BuildContext context) {
    if (stateCode == 'TT') {
      return _buildCountryTimeSeries();
    }

    return _buildStateTimeSeries();
  }

  Widget _buildCountryTimeSeries() {
    return Center(
      child: BlocBuilder<CountryTimeSeriesBloc.TimeSeriesBloc,
          CountryTimeSeriesBloc.TimeSeriesState>(
        builder: (context, state) {
          if (state is CountryTimeSeriesBloc.Empty) {
            return MessageDisplay(
              message: 'Empty',
            );
          } else if (state is CountryTimeSeriesBloc.Loading) {
            return LoadingWidget(height: 72);
          } else if (state is CountryTimeSeriesBloc.Loaded) {
            Map<String, StateWiseTimeSeries> timeSeriesMap =
                _getTimeSeriesMap(state.timeSeries);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTimeSeries(timeSeriesMap),
            );
          } else if (state is CountryTimeSeriesBloc.Error) {
            return MessageDisplay(
              message: state.message,
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildStateTimeSeries() {
    return Center(
      child: BlocBuilder<StateTimeSeriesBloc.StateTimeSeriesBloc,
          StateTimeSeriesBloc.StateTimeSeriesState>(
        builder: (context, state) {
          if (state is StateTimeSeriesBloc.Empty) {
            return MessageDisplay(
              message: 'Empty',
            );
          } else if (state is StateTimeSeriesBloc.Loading) {
            return LoadingWidget(height: 72);
          } else if (state is StateTimeSeriesBloc.Loaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  _buildTimeSeries({state.timeSeries.name: state.timeSeries}),
            );
          } else if (state is StateTimeSeriesBloc.Error) {
            return MessageDisplay(
              message: state.message,
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildTimeSeries(Map<String, StateWiseTimeSeries> timeSeries) {
    return TimeSeriesExplorer(
      timeSeries: timeSeries,
      stateCode: stateCode,
      timelineDate: timelineDate,
      regionHighlighted: regionHighlighted,
      setRegionHighlighted: setRegionHighlighted,
    );
  }

  Map<String, StateWiseTimeSeries> _getTimeSeriesMap(
      List<StateWiseTimeSeries> timeSeries) {
    return Map.fromIterable(timeSeries, key: (e) => e.name, value: (e) => e);
  }
}

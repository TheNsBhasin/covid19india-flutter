import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSeriesExplorerWidget extends StatelessWidget {
  final DateTime date;

  TimeSeriesExplorerWidget({this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<TimeSeriesBloc, TimeSeriesState>(
          builder: (context, state) {
            if (state is Empty) {
              return MessageDisplay(
                message: 'Empty',
              );
            } else if (state is Loading) {
              return LoadingWidget(height: 72);
            } else if (state is Loaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildTimeSeries(state.timeSeries),
              );
            } else if (state is Error) {
              return MessageDisplay(
                message: state.message,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildTimeSeries(timeSeries) {
    return TimeSeriesExplorer(
        timeSeriesMap: _getTimeSeriesMap(timeSeries), date: date);
  }

  Map<String, List<TimeSeries>> _getTimeSeriesMap(
      List<StateWiseTimeSeries> timeSeries) {
    return Map.fromIterable(timeSeries,
        key: (e) => e.name, value: (e) => e.timeSeries);
  }
}

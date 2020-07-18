import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/minigraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSeriesMiniGraphWidget extends StatelessWidget {
  final MapCodes mapCodes;

  TimeSeriesMiniGraphWidget({this.mapCodes});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<TimeSeriesBloc, TimeSeriesState>(
        builder: (context, state) {
          if (state is TimeSeriesLoadInProgress) {
            return LoadingWidget(height: 72);
          } else if (state is TimeSeriesLoadSuccess) {
            Map<MapCodes, StateTimeSeries> timeSeriesMap =
                _getTimeSeriesMap(state.timeSeries);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<DateBloc, DateTime>(
                builder: (context, date) {
                  return MiniGraph(
                      timeSeries: timeSeriesMap[mapCodes].timeSeries,
                      date: date);
                },
              ),
            );
          } else if (state is TimeSeriesLoadFailure) {
            return MessageDisplay(
              message: state.message,
            );
          }

          return Container();
        },
      ),
    );
  }

  Map<MapCodes, StateTimeSeries> _getTimeSeriesMap(
      List<StateTimeSeries> timeSeries) {
    return Map.fromIterable(timeSeries,
        key: (e) => e.stateCode, value: (e) => e);
  }
}

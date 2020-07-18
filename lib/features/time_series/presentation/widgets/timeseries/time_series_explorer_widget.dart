import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSeriesExplorerWidget extends StatelessWidget {
  final MapCodes stateCode;

  TimeSeriesExplorerWidget({
    this.stateCode,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<TimeSeriesBloc, TimeSeriesState>(
        builder: (context, state) {
          if (state is TimeSeriesLoadInProgress) {
            return LoadingWidget(height: 72);
          } else if (state is TimeSeriesLoadSuccess) {
            final Map<MapCodes, StateTimeSeries> timeSeriesMap =
                _getTimeSeriesMap(state.timeSeries);

            if (!timeSeriesMap.containsKey(stateCode)) {
              return Container();
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TimeSeriesExplorer(
                timeSeries: stateCode == MapCodes.TT
                    ? timeSeriesMap
                    : {stateCode: timeSeriesMap[stateCode]},
                stateCode: stateCode,
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

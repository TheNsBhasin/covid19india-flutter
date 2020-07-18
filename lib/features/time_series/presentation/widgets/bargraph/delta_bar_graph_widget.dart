import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/statistic.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/bargraph/delta_bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeltaBarGraphWidget extends StatelessWidget {
  final MapCodes stateCode;

  DeltaBarGraphWidget({this.stateCode});

  @override
  Widget build(BuildContext context) {
    return Center(child: BlocBuilder<TimeSeriesBloc, TimeSeriesState>(
      builder: (context, state) {
        if (state is TimeSeriesLoadInProgress) {
          return LoadingWidget(height: 72);
        } else if (state is TimeSeriesLoadSuccess) {
          StateTimeSeries stateTimeSeries = state.timeSeries
              .firstWhere((stateData) => stateData.stateCode == stateCode);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<StatisticBloc, Statistic>(
                builder: (context, statistic) {
              return DeltaBarGraph(
                timeSeries: stateTimeSeries,
                stateCode: stateCode,
                statistic: statistic,
              );
            }),
          );
        } else if (state is TimeSeriesLoadFailure) {
          return MessageDisplay(
            message: state.message,
          );
        }

        return Container();
      },
    ));
  }
}

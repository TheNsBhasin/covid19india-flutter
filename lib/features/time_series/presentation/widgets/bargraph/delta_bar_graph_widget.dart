import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/state_time_series/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/bargraph/delta_bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeltaBarGraphWidget extends StatelessWidget {
  final String stateCode;
  final String statistic;
  final int lookback;

  DeltaBarGraphWidget({this.stateCode, this.statistic, this.lookback});

  @override
  Widget build(BuildContext context) {
    return Center(child: BlocBuilder<StateTimeSeriesBloc, StateTimeSeriesState>(
      builder: (context, state) {
        if (state is Empty) {
          return MessageDisplay(
            message: 'Empty',
          );
        } else if (state is Loading) {
          return LoadingWidget(height: 72);
        } else if (state is Loaded) {
          StateWiseTimeSeries stateTimeSeries = state.timeSeries;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildDeltaBarGraph(context, stateTimeSeries),
          );
        } else if (state is Error) {
          return MessageDisplay(
            message: state.message,
          );
        }

        return Container();
      },
    ));
  }

  Widget buildDeltaBarGraph(
      BuildContext context, StateWiseTimeSeries timeSeries) {
    return DeltaBarGraph(
      timeSeries: timeSeries,
      stateCode: stateCode,
      statistic: statistic,
      lookback: lookback,
    );
  }
}

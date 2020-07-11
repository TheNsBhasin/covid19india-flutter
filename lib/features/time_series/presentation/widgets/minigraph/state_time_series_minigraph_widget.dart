import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/state_time_series/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/minigraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StateTimeSeriesMiniGraphWidget extends StatelessWidget {
  final DateTime date;

  StateTimeSeriesMiniGraphWidget({this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<StateTimeSeriesBloc, StateTimeSeriesState>(
        builder: (context, state) {
          if (state is Empty) {
            return MessageDisplay(
              message: 'Empty',
            );
          } else if (state is Loading) {
            return LoadingWidget(height: 72);
          } else if (state is Loaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMiniGraph(state.timeSeries.timeSeries),
            );
          } else if (state is Error) {
            return MessageDisplay(
              message: state.message,
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildMiniGraph(List<TimeSeries> timeSeries) {
    return MiniGraph(timeSeries: timeSeries, date: date);
  }
}

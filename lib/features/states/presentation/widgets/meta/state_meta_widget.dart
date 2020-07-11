import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart'
    as DailyCountBloc;
import 'package:covid19india/features/states/presentation/widgets/meta/state_meta.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/state_time_series/bloc.dart'
    as StateTimeSeriesBloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StateMetaWidget extends StatelessWidget {
  final String stateCode;

  StateMetaWidget({this.stateCode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DailyCountBloc.DailyCountBloc,
          DailyCountBloc.DailyCountState>(
        builder: (context, state) {
          if (state is DailyCountBloc.Empty) {
            return MessageDisplay(
              message: 'Empty',
            );
          } else if (state is DailyCountBloc.Loading) {
            return LoadingWidget(
              height: 100,
            );
          } else if (state is DailyCountBloc.Loaded) {
            Map<String, StateWiseDailyCount> stateDailyCountMap =
                _getStateWiseDailyCountMap(state.dailyCounts);

            return BlocBuilder<StateTimeSeriesBloc.StateTimeSeriesBloc,
                StateTimeSeriesBloc.StateTimeSeriesState>(
              builder: (context, state) {
                if (state is StateTimeSeriesBloc.Empty) {
                  return MessageDisplay(
                    message: 'Empty',
                  );
                } else if (state is StateTimeSeriesBloc.Loading) {
                  return LoadingWidget(height: 72);
                } else if (state is StateTimeSeriesBloc.Loaded) {
                  StateWiseTimeSeries stateTimeSeries = state.timeSeries;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildStateMeta(
                        context, stateDailyCountMap, stateTimeSeries),
                  );
                } else if (state is StateTimeSeriesBloc.Error) {
                  return MessageDisplay(
                    message: state.message,
                  );
                }

                return Container();
              },
            );
          } else if (state is DailyCountBloc.Error) {
            return MessageDisplay(
              message: state.message,
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget buildStateMeta(
      BuildContext context,
      Map<String, StateWiseDailyCount> dailyCount,
      StateWiseTimeSeries timeSeries) {
    return StateMeta(
      stateCode: stateCode,
      dailyCount: dailyCount,
      timeSeries: timeSeries,
    );
  }

  Map<String, StateWiseDailyCount> _getStateWiseDailyCountMap(
      List<StateWiseDailyCount> dailyCounts) {
    return Map.fromIterable(dailyCounts, key: (e) => e.name, value: (e) => e);
  }
}

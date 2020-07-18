import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/states/presentation/widgets/meta/state_meta.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StateMetaWidget extends StatelessWidget {
  final MapCodes stateCode;

  StateMetaWidget({this.stateCode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DailyCountBloc, DailyCountState>(
        builder: (context, state) {
          if (state is DailyCountLoadInProgress) {
            return LoadingWidget(
              height: 100,
            );
          } else if (state is DailyCountLoadSuccess) {
            Map<MapCodes, StateDailyCount> stateDailyCountMap =
                _getStateWiseDailyCountMap(state.dailyCounts);

            return BlocBuilder<TimeSeriesBloc, TimeSeriesState>(
              builder: (context, state) {
                if (state is TimeSeriesLoadInProgress) {
                  return LoadingWidget(height: 72);
                } else if (state is TimeSeriesLoadSuccess) {
                  StateTimeSeries stateTimeSeries = state.timeSeries.firstWhere(
                      (stateData) => stateData.stateCode == stateCode);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildStateMeta(
                        context, stateDailyCountMap, stateTimeSeries),
                  );
                } else if (state is TimeSeriesLoadFailure) {
                  return MessageDisplay(
                    message: state.message,
                  );
                }

                return Container();
              },
            );
          } else if (state is DailyCountLoadFailure) {
            return MessageDisplay(
              message: state.message,
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget buildStateMeta(BuildContext context,
      Map<MapCodes, StateDailyCount> dailyCount, StateTimeSeries timeSeries) {
    return StateMeta(
      stateCode: stateCode,
      dailyCount: dailyCount,
      timeSeries: timeSeries,
    );
  }

  Map<MapCodes, StateDailyCount> _getStateWiseDailyCountMap(
      List<StateDailyCount> dailyCounts) {
    return Map.fromIterable(dailyCounts,
        key: (e) => e.stateCode, value: (e) => e);
  }
}

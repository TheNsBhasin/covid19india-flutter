import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:covid19india/core/entity/statistic.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/district/district_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DistrictTopWidget extends StatelessWidget {
  final MapCodes stateCode;

  DistrictTopWidget({this.stateCode});

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

            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<StatisticBloc, Statistic>(
                    builder: (context, statistic) {
                  return DistrictTop(
                    stateCode: stateCode,
                    statistic: statistic,
                    stateDailyCount: stateDailyCountMap[stateCode],
                  );
                }));
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

  Map<MapCodes, StateDailyCount> _getStateWiseDailyCountMap(
      List<StateDailyCount> dailyCounts) {
    return Map.fromIterable(dailyCounts,
        key: (e) => e.stateCode, value: (e) => e);
  }
}

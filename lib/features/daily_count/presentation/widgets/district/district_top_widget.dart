import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/district/district_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DistrictTopWidget extends StatelessWidget {
  final String stateCode;
  final String statistic;

  DistrictTopWidget({this.stateCode, this.statistic});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DailyCountBloc, DailyCountState>(
        builder: (context, state) {
          if (state is Empty) {
            return MessageDisplay(
              message: 'Empty',
            );
          } else if (state is Loading) {
            return LoadingWidget(
              height: 100,
            );
          } else if (state is Loaded) {
            Map<String, StateWiseDailyCount> stateDailyCountMap =
                _getStateWiseDailyCountMap(state.dailyCounts);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildDistrictBar(context, stateDailyCountMap),
            );
          } else if (state is Error) {
            return MessageDisplay(
              message: state.message,
            );
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(),
          );
        },
      ),
    );
  }

  Widget buildDistrictBar(
      BuildContext context, Map<String, StateWiseDailyCount> dailyCount) {
    return DistrictTop(
      stateCode: stateCode,
      statistic: statistic,
      stateDailyCount: dailyCount[stateCode],
    );
  }

  Map<String, StateWiseDailyCount> _getStateWiseDailyCountMap(
      List<StateWiseDailyCount> dailyCounts) {
    return Map.fromIterable(dailyCounts, key: (e) => e.name, value: (e) => e);
  }
}

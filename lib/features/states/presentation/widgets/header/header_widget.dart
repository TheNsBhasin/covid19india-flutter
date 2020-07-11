import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/states/presentation/widgets/header/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderWidget extends StatelessWidget {
  final String stateCode;
  final String statistic;

  HeaderWidget({this.stateCode, this.statistic});

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
            Map<String, StateWiseDailyCount> stateMap =
                _getStateWiseDailyCountMap(state.dailyCounts);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildHeader(context, stateMap[stateCode]),
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

  Widget buildHeader(BuildContext context, StateWiseDailyCount dailyCount) {
    return Header(stateDailyCount: dailyCount, statistic: statistic);
  }

  Map<String, StateWiseDailyCount> _getStateWiseDailyCountMap(
      List<StateWiseDailyCount> dailyCounts) {
    return Map.fromIterable(dailyCounts, key: (e) => e.name, value: (e) => e);
  }
}

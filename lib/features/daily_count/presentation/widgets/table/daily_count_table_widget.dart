import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/table/daily_count_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyCountTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<DailyCountBloc, DailyCountState>(
          builder: (context, state) {
            if (state is Empty) {
              return MessageDisplay(
                message: 'Empty',
              );
            } else if (state is Loading) {
              return LoadingWidget();
            } else if (state is Loaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: buildDailyCountTable(context, state.dailyCounts),
              );
            } else if (state is Error) {
              return MessageDisplay(
                message: state.message,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget buildDailyCountTable(BuildContext context, dailyCounts) {
    return IntrinsicHeight(
      child: DailyCountTable(
        stateWiseDailyCount: _getStateWiseDailyCountMap(dailyCounts),
        districtWiseDailyCount: _getDistrictWiseDailyCountMap(dailyCounts),
      ),
    );
  }

  Map<String, StateWiseDailyCount> _getStateWiseDailyCountMap(
      List<StateWiseDailyCount> dailyCounts) {
    return Map.fromIterable(dailyCounts, key: (e) => e.name, value: (e) => e);
  }

  Map<String, DistrictWiseDailyCount> _getDistrictWiseDailyCountMap(
      List<StateWiseDailyCount> dailyCounts) {
    Map<String, DistrictWiseDailyCount> dailyCountMap = {};

    dailyCounts.forEach((stateDailyCount) {
      stateDailyCount.districts.forEach((districtDailyCount) {
        dailyCountMap[districtDailyCount.name] = districtDailyCount;
      });
    });

    return dailyCountMap;
  }
}

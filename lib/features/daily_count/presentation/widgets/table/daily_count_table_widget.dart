import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
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
            if (state is DailyCountLoadInProgress) {
              return LoadingWidget();
            } else if (state is DailyCountLoadSuccess) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: buildDailyCountTable(context, state.dailyCounts),
              );
            } else if (state is DailyCountLoadFailure) {
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
        stateDailyCounts: _getStateWiseDailyCountMap(dailyCounts),
        districtDailyCounts: _getDistrictWiseDailyCountMap(dailyCounts),
      ),
    );
  }

  Map<MapCodes, StateDailyCount> _getStateWiseDailyCountMap(
      List<StateDailyCount> dailyCounts) {
    return Map.fromIterable(dailyCounts,
        key: (e) => e.stateCode, value: (e) => e);
  }

  Map<String, DistrictDailyCount> _getDistrictWiseDailyCountMap(
      List<StateDailyCount> dailyCounts) {
    Map<String, DistrictDailyCount> dailyCountMap = {};

    dailyCounts.forEach((stateDailyCount) {
      stateDailyCount.districts.forEach((districtDailyCount) {
        dailyCountMap[districtDailyCount.name] = districtDailyCount;
      });
    });

    return dailyCountMap;
  }
}

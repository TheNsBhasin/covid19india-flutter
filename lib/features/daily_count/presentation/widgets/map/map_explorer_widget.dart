import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_explorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapExplorerWidget extends StatelessWidget {
  final String stateCode;
  final String statistic;
  final Map<String, String> regionHighlighted;

  final Function(String statistic) setStatistic;
  final Function(Map<String, String> regionHighlighted) setRegionHighlighted;

  MapExplorerWidget(
      {this.statistic,
      this.stateCode: 'TT',
      this.setStatistic,
      this.regionHighlighted,
      this.setRegionHighlighted});

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
            return LoadingWidget();
          } else if (state is Loaded) {
            Map<String, StateWiseDailyCount> stateDailyCountMap =
                _getDailyCountMap(state.dailyCounts);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildMapExplorer(stateDailyCountMap),
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

  Widget buildMapExplorer(Map<String, StateWiseDailyCount> stateDailyCountMap) {
    return MapExplorer(
      dailyCounts: stateDailyCountMap,
      statistic: statistic,
      setStatistic: setStatistic,
      mapCode: stateCode,
      regionHighlighted: regionHighlighted,
      setRegionHighlighted: setRegionHighlighted,
    );
  }

  Map<String, StateWiseDailyCount> _getDailyCountMap(
      List<StateWiseDailyCount> dailyCounts) {
    return Map.fromIterable(dailyCounts, key: (e) => e.name, value: (e) => e);
  }
}

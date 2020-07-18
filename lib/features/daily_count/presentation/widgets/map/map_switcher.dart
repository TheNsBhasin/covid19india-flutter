import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/statistic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapSwitcherItem extends StatelessWidget {
  final double height;
  final bool show;
  final Statistic statistic;

  MapSwitcherItem({this.height, this.statistic, this.show});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: height),
      color:
          show ? STATS_COLOR[statistic].withOpacity(0.25) : Colors.transparent,
    );
  }
}

class MapSwitcher extends StatelessWidget {
  final double height;

  MapSwitcher({this.height});

  @override
  Widget build(BuildContext context) {
    if (height == 0) {
      return SizedBox.shrink();
    }

    return BlocBuilder<StatisticBloc, Statistic>(
      builder: (context, statistic) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...PRIMARY_STATISTICS.map((stats) => Expanded(
                    child: GestureDetector(
                      onTap: () => () {
                        context
                            .bloc<StatisticBloc>()
                            .add(StatisticChanged(statistic: stats));
                      },
                      child: MapSwitcherItem(
                        height: height,
                        statistic: stats,
                        show: statistic == stats,
                      ),
                    ),
                  ))
            ],
          ),
        );
      },
    );
  }
}

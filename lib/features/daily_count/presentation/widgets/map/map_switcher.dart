import 'package:covid19india/core/constants/constants.dart';
import 'package:flutter/material.dart';

class MapSwitcherItem extends StatelessWidget {
  final double height;
  final bool show;
  final STATISTIC statistic;

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
  final STATISTIC statistic;
  final Null Function(STATISTIC statistic) setStatistic;
  final double height;

  MapSwitcher({this.height, this.statistic, this.setStatistic});

  @override
  Widget build(BuildContext context) {
    if (height == 0) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...PRIMARY_STATISTICS.map((statistic) => Expanded(
                child: GestureDetector(
                  onTap: () => setStatistic(statistic),
                  child: MapSwitcherItem(
                    height: height,
                    statistic: statistic,
                    show: statistic == this.statistic,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

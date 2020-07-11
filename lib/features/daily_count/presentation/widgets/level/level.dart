import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/stats.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LevelItem extends StatelessWidget {
  final String statistics;
  final Stats total;
  final Stats delta;

  LevelItem({this.statistics, this.total, this.delta});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(statistics.capitalize(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: STATS_COLOR[statistics])),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
                getStatisticValue(delta, statistics) > 0
                    ? "+" +
                        NumberFormat.decimalPattern('en_IN').format(
                            getStatisticValue(delta, statistics))
                    : "♥",
                style: TextStyle(fontSize: 12, color: STATS_COLOR[statistics])),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
                NumberFormat.decimalPattern('en_IN')
                    .format(getStatisticValue(total, statistics)),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: STATS_COLOR[statistics])),
          ),
        ],
      ),
    );
  }
}

class Level extends StatelessWidget {
  final StateWiseDailyCount dailyCount;

  Level(this.dailyCount);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ...PRIMARY_STATISTICS.map((statistic) => Expanded(
                child: LevelItem(
                    statistics: statistic,
                    total: dailyCount.total,
                    delta: dailyCount.delta),
              ))
        ],
      ),
    );
  }
}

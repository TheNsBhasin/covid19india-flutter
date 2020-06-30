import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
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
                    fontSize: 14, fontWeight: FontWeight.bold, color: Constants.STATS_COLOR[statistics])),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
                _getStatistics(delta, statistics) > 0
                    ? "+" +
                        NumberFormat.decimalPattern('en_IN')
                            .format(_getStatistics(delta, statistics))
                    : "",
                style: TextStyle(
                    fontSize: 12, color: Constants.STATS_COLOR[statistics])),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
                NumberFormat.decimalPattern('en_IN')
                    .format(_getStatistics(total, statistics)),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Constants.STATS_COLOR[statistics])),
          ),
        ],
      ),
    );
  }

  int _getStatistics(Stats data, statistics) {
    if (statistics == 'confirmed') {
      return data.confirmed;
    } else if (statistics == 'active') {
      return data.active;
    } else if (statistics == 'recovered') {
      return data.recovered;
    } else if (statistics == 'deceased') {
      return data.deceased;
    } else if (statistics == 'tested') {
      return data.tested;
    }

    return data.confirmed;
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
          LevelItem(
              statistics: 'confirmed',
              total: dailyCount.total,
              delta: dailyCount.delta),
          LevelItem(
              statistics: 'active',
              total: dailyCount.total,
              delta: dailyCount.delta),
          LevelItem(
              statistics: 'recovered',
              total: dailyCount.total,
              delta: dailyCount.delta),
          LevelItem(
              statistics: 'deceased',
              total: dailyCount.total,
              delta: dailyCount.delta)
        ],
      ),
    );
  }
}

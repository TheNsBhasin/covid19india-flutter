import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/features/daily_count/domain/entities/metadata.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MapStatsItem extends StatelessWidget {
  final String statistics;
  final Stats total;
  final Stats delta;
  final Metadata metadata;

  MapStatsItem({this.statistics, this.total, this.delta, this.metadata});

  @override
  Widget build(BuildContext context) {
    if (statistics == 'tested') {
      return _buildTestedItem();
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 100, minHeight: 90),
      child: Container(
        decoration: BoxDecoration(
            color: Constants.STATS_COLOR[statistics].withAlpha(50),
            borderRadius: BorderRadius.all(new Radius.circular(5.0))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(statistics.capitalize(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Constants.STATS_COLOR[statistics])),
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
                        fontSize: 12,
                        color: Constants.STATS_COLOR[statistics])),
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
        ),
      ),
    );
  }

  Widget _buildTestedItem() {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 100),
      child: Container(
        decoration: BoxDecoration(
            color: Constants.STATS_COLOR[statistics].withAlpha(50),
            borderRadius: BorderRadius.all(new Radius.circular(5.0))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(statistics.capitalize(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Constants.STATS_COLOR[statistics])),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(_formatLastUpdateText(),
                    style: TextStyle(
                        fontSize: 12,
                        color: Constants.STATS_COLOR[statistics])),
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
        ),
      ),
    );
  }

  String _formatLastUpdateText() {
    if (metadata.tested['last_updated'] == null) {
      return "";
    }

    return "As of " +
        (new DateFormat('d MMMM')
            .format(DateTime.parse(metadata.tested['last_updated']).toLocal()));
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

class MapStats extends StatelessWidget {
  final StateWiseDailyCount dailyCount;
  final Null Function(String selected) onSelectStats;

  MapStats({this.dailyCount, this.onSelectStats});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ...Constants.MAP_STATISTICS.map((statistics) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        onSelectStats(statistics);
                      },
                      child: MapStatsItem(
                          statistics: statistics,
                          total: dailyCount.total,
                          delta: dailyCount.delta,
                          metadata: dailyCount.metadata),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

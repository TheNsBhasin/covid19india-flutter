import 'package:covid19india/core/common/widgets/alert_box.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/statistic.dart';
import 'package:covid19india/core/entity/statistic_type.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/formatter.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:covid19india/features/states/presentation/widgets/meta/state_meta_card.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StateMeta extends StatelessWidget {
  final MapCodes stateCode;
  final Map<MapCodes, StateDailyCount> dailyCount;
  final StateTimeSeries timeSeries;

  StateMeta({this.stateCode, this.dailyCount, this.timeSeries});

  @override
  Widget build(BuildContext context) {
    final int confirmed =
        getStatisticValue(dailyCount[stateCode].total, Statistic.confirmed);
    final int active =
        getStatisticValue(dailyCount[stateCode].total, Statistic.active);
    final int deceased =
        getStatisticValue(dailyCount[stateCode].total, Statistic.deceased);
    final int recovered =
        getStatisticValue(dailyCount[stateCode].total, Statistic.recovered);
    final int tested =
        getStatisticValue(dailyCount[stateCode].total, Statistic.tested);

    final DateTime indiaDate = DateTime.now().toLocal();
    final DateTime prevWeekDate = indiaDate.subtract(Duration(days: 7));

    final TimeSeries prevWeekTimeSeries = timeSeries.timeSeries
        .where((e) => e.date.isSameDay(prevWeekDate))
        .first;

    final int prevWeekConfirmed =
        getStatisticValue(prevWeekTimeSeries.total, Statistic.confirmed);

    final int confirmedPerMillion = getStatistics(
        dailyCount[stateCode], StatisticType.total, Statistic.confirmed,
        perMillion: true);
    final int testPerMillion = getStatistics(
        dailyCount[stateCode], StatisticType.total, Statistic.tested,
        perMillion: true);
    final int totalConfirmedPerMillion = getStatistics(
        dailyCount[MapCodes.TT], StatisticType.total, Statistic.confirmed,
        perMillion: true);

    final double recoveryPercent = (recovered / confirmed) * 100;
    final double activePercent = (active / confirmed) * 100;
    final double deathPercent = (deceased / confirmed) * 100;

    final double growthRate =
        ((confirmed - prevWeekConfirmed) / prevWeekConfirmed) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (dailyCount[stateCode].metadata.population != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Population',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          NumberFormat.decimalPattern('en_IN').format(
                              dailyCount[stateCode].metadata.population),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 128,
                  child: AlertBox(
                      icon: Icon(
                        Icons.info,
                        size: 14,
                      ),
                      text: "Based on 2019 population projection by NCP"),
                )
              ],
            ),
          SizedBox(height: 16),
          Wrap(
            children: [
              StateMetaCard(
                title: 'Confirmed Per Million',
                statistic: NumberFormat.decimalPattern('en_IN')
                    .format(confirmedPerMillion),
                total: NumberFormat.decimalPattern('en_IN')
                    .format(totalConfirmedPerMillion),
                date: null,
                formula: '(confirmed / state population) * 1 Million',
                description:
                    "${NumberFormat.decimalPattern('en_IN').format(confirmedPerMillion.round())} out of every 1 million people in ${stateCode.name} have tested positive for the virus.",
                color: Colors.red,
              ),
              StateMetaCard(
                title: 'Active',
                statistic:
                    "${NumberFormat.decimalPattern('en_IN').format(activePercent)}%",
                total: null,
                date: null,
                formula: '(active / confirmed) * 100',
                description: activePercent > 0
                    ? "For every 100 confirmed cases, ${NumberFormat.decimalPattern('en_IN').format(activePercent.round())} are currently infected."
                    : "Currently, there are no active cases in this state.",
                color: Colors.blue,
              ),
              StateMetaCard(
                title: 'Recovery Rate',
                statistic:
                    "${NumberFormat.decimalPattern('en_IN').format(recoveryPercent)}%",
                total: null,
                date: null,
                formula: '(recovered / confirmed) * 100',
                description: recoveryPercent > 0
                    ? "For every 100 confirmed cases, ${NumberFormat.decimalPattern('en_IN').format(recoveryPercent.round())} have recovered from the virus."
                    : "Unfortunately, there are no recoveries in this state yet.",
                color: Colors.green,
              ),
              StateMetaCard(
                title: 'Mortality Rate',
                statistic:
                    "${NumberFormat.decimalPattern('en_IN').format(deathPercent)}%",
                total: null,
                date: null,
                formula: '(deceased / confirmed) * 100',
                description: deathPercent > 0
                    ? "For every 100 confirmed cases, ${NumberFormat.decimalPattern('en_IN').format(deathPercent.round())} have unfortunately passed away from the virus."
                    : "Fortunately, no one has passed away from the virus in this state.",
                color: Colors.grey,
              ),
              StateMetaCard(
                title: 'Avg. Growth Rate',
                statistic: growthRate > 0
                    ? "${NumberFormat.decimalPattern('en_IN').format(growthRate / 7)}%"
                    : "-",
                total: null,
                date:
                    "${DateFormat("dd MMM,").format(prevWeekDate)} - ${DateFormat("dd MMM,").format(indiaDate)}",
                formula:
                    '(((previousDayData - sevenDayBeforeData) / sevenDayBeforeData) * 100)/7',
                description: growthRate > 0
                    ? "In the last one week, the number of new infections has grown by an average of ${NumberFormat.decimalPattern('en_IN').format((growthRate / 7).round())}% every day."
                    : "There has been no growth in the number of infections in last one week.",
                color: Colors.orange,
              ),
              StateMetaCard(
                title: 'Tests Per Million',
                statistic:
                    "≈ ${NumberFormat.decimalPattern('en_IN').format(testPerMillion)}",
                total: null,
                date: tested != null
                    ? "As of ${Formatter.formatDuration(indiaDate.difference(DateTime.parse(dailyCount[stateCode].metadata.tested['last_updated'])))} ago"
                    : "",
                formula:
                    '(total tests in state / total population of state) * 1 Million',
                description: testPerMillion > 0
                    ? "For every 1 million people in ${stateCode.name}, ${NumberFormat.decimalPattern('en_IN').format(testPerMillion.round())} people were tested."
                    : "No tests have been conducted in this state yet.",
                color: Colors.purple,
              ),
            ],
          )
        ],
      ),
    );
  }
}

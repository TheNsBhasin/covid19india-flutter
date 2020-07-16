import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Header extends StatelessWidget {
  final StateWiseDailyCount stateDailyCount;
  final STATISTIC statistic;

  Header({this.stateDailyCount, this.statistic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    STATE_CODE_MAP[stateDailyCount.name],
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: STATS_COLOR[statistic]),
                  ),
                ),
                if (stateDailyCount.metadata.lastUpdated != null)
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      "Last Updated on ${DateFormat("dd MMM,").add_jm().format(DateTime.parse(stateDailyCount.metadata.lastUpdated).toLocal())}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Text("Tested",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: STATS_COLOR['tested'])),
                ),
                Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                      NumberFormat.decimalPattern('en_IN').format(
                          getStatisticValue(stateDailyCount.total, STATISTIC.TESTED)),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: STATS_COLOR['tested'])),
                ),
                if (stateDailyCount.metadata.tested.containsKey('last_updated'))
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                          text:
                              "As of ${DateFormat("dd MMM").format(DateTime.parse(stateDailyCount.metadata.tested['last_updated']))}",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: STATS_COLOR['tested']),
                          children: [
                            TextSpan(
                                text: "\nAs per source",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: STATS_COLOR['tested'])),
                          ]),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

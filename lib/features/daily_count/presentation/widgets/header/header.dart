import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/statistic.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Header extends StatelessWidget {
  final StateDailyCount stateDailyCount;

  Header({this.stateDailyCount});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticBloc, Statistic>(
      builder: (context, statistic) {
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
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        stateDailyCount.stateCode.name,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: STATS_COLOR[statistic]),
                      ),
                    ),
                    if (stateDailyCount.metadata.lastUpdated != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 2.0),
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
                              color: STATS_COLOR[Statistic.tested])),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                            NumberFormat.decimalPattern('en_IN').format(
                                getStatisticValue(
                                    stateDailyCount.total, Statistic.tested)),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: STATS_COLOR[Statistic.tested])),
                      ),
                    ),
                    if (stateDailyCount.metadata.tested
                        .containsKey('last_updated'))
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
                                  color: STATS_COLOR[Statistic.tested]),
                              children: [
                                TextSpan(
                                    text: "\nAs per source",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: STATS_COLOR[Statistic.tested])),
                              ]),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

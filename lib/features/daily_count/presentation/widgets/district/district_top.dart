import 'dart:math';

import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DistrictTop extends StatefulWidget {
  final String stateCode;
  final String statistic;

  final StateWiseDailyCount stateDailyCount;

  DistrictTop({this.stateCode, this.statistic, this.stateDailyCount});

  @override
  _DistrictTopState createState() => _DistrictTopState();
}

class _DistrictTopState extends State<DistrictTop> {
  bool showAllDistricts;

  @override
  void initState() {
    super.initState();

    showAllDistricts = false;
  }

  @override
  Widget build(BuildContext context) {
    final List<DistrictWiseDailyCount> districtDailyCount =
        _getDistrictDailyCount(widget.stateDailyCount, widget.statistic,
            count: showAllDistricts ? null : 5);

    final int gridColumnCount =
        MediaQuery.of(context).size.width >= 540 ? 3 : 2;
    final int districtCount = districtDailyCount?.length ?? 0;

    final int gridRowCount = (districtCount / gridColumnCount).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'Top districts',
                  style: TextStyle(
                      color: STATS_COLOR[widget.statistic],
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List<int>.generate(gridColumnCount, (index) => index)
                  .map((index) => Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...districtDailyCount
                                .sublist(
                                    index * gridRowCount,
                                    min((index + 1) * gridRowCount,
                                        districtDailyCount.length))
                                .map((districtData) {
                              final String districtName = districtData.name;

                              final int total = getStatistics(
                                  districtData, 'total', widget.statistic);
                              final int delta = getStatistics(
                                  districtData, 'delta', widget.statistic);

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Text(
                                        NumberFormat.decimalPattern('en_IN')
                                            .format(total),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Container(
                                      child: Flexible(
                                        child: Text(
                                          districtName,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.0),
                                    if (delta > 0)
                                      Container(
                                        child: Text(
                                          "\u2191 ${NumberFormat.decimalPattern('en_IN').format(delta)}",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: STATS_COLOR[
                                                  widget.statistic]),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ))
            ],
          ),
          SizedBox(height: 8),
          if (districtDailyCount.length <
              widget.stateDailyCount.districts.length)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton.icon(
                    onPressed: () => {
                          setState(() {
                            showAllDistricts = !showAllDistricts;
                          })
                        },
                    icon: FaIcon(
                      showAllDistricts
                          ? FontAwesomeIcons.arrowUp
                          : FontAwesomeIcons.arrowDown,
                      color: Colors.grey,
                      size: 14,
                    ),
                    label: Text(
                      showAllDistricts ? "View less" : "View all",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    )),
              ],
            ),
        ],
      ),
    );
  }

  List<DistrictWiseDailyCount> _getDistrictDailyCount(
      StateWiseDailyCount stateDailyCount, String statistic,
      {int count}) {
    List<DistrictWiseDailyCount> sortedList = stateDailyCount.districts
        .where((e) => e.name != UNKNOWN_DISTRICT_KEY)
        .toList()
          ..sort((a, b) {
            int statsA = getStatisticValue(a.total, statistic);
            int statsB = getStatisticValue(b.total, statistic);

            return statsB.compareTo(statsA);
          });

    return sortedList
        .sublist(0,
            count == null ? sortedList.length : min(count, sortedList.length))
        .toList();
  }
}

import 'dart:math';

import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/formatter.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Updates extends StatelessWidget {
  final List<UpdateLog> updateLogs;
  final int limit;

  Updates({this.updateLogs, this.limit});

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<UpdateLog>> dayWiseUpdateLog = _getDayWiseUpdateLog(
        limit != null
            ? updateLogs.reversed
                .toList()
                .sublist(0, min(limit, updateLogs.length))
            : updateLogs.reversed.toList());

    final bool isDarkMode = Theme.of(context).brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...dayWiseUpdateLog.entries
              .map((e) =>
                  _buildDayUpdates(e.key, e.value, isDarkMode: isDarkMode))
              .toList()
        ],
      ),
    );
  }

  Widget _buildDayUpdates(DateTime day, List<UpdateLog> updateLogs,
      {bool isDarkMode: false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              new DateFormat('d MMM').format(day.toLocal()),
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...updateLogs.reversed
                  .toList()
                  .map((updateLog) =>
                      _buildUpdateTile(updateLog, isDarkMode: isDarkMode))
                  .toList()
            ],
          ),
        ),
      ],
    );
  }

  _buildUpdateTile(UpdateLog updateLog, {bool isDarkMode: false}) {
    List<String> notes = updateLog.update.split("\n");
    notes.removeLast();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.grey.withOpacity(0.2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${Formatter.formatDuration(DateTime.now().difference(updateLog.timestamp))} ago"
                  .capitalize(),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 4.0),
            ...notes.map((note) => Text(
                  note,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.black87 : Colors.white70),
                ))
          ],
        ),
      ),
    );
  }

  Map<DateTime, List<UpdateLog>> _getDayWiseUpdateLog(
      List<UpdateLog> updateLogs) {
    Map<DateTime, List<UpdateLog>> dayWiseUpdateLog = {};

    updateLogs.forEach((updateLog) {
      DateTime day = new DateTime(updateLog.timestamp.year,
          updateLog.timestamp.month, updateLog.timestamp.day);

      if (!dayWiseUpdateLog.containsKey(day)) {
        dayWiseUpdateLog[day] = [];
      }

      dayWiseUpdateLog[day].add(updateLog);
    });

    dayWiseUpdateLog.forEach((key, value) {
      value.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });

    return dayWiseUpdateLog;
  }
}

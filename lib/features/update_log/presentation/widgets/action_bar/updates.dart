import 'package:covid19india/core/util/formatter.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Updates extends StatefulWidget {
  final List<UpdateLog> updateLogs;

  Updates({this.updateLogs});

  @override
  _UpdatesState createState() => _UpdatesState(updateLogs: updateLogs);
}

class _UpdatesState extends State<Updates> {
  final List<UpdateLog> updateLogs;

  _UpdatesState({this.updateLogs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                new DateFormat('d MMM').format(DateTime.now().toLocal()),
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...updateLogs.reversed
                    .toList()
                    .sublist(0, 5)
                    .map((updateLog) => _buildUpdateTile(updateLog))
                    .toList()
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildUpdateTile(UpdateLog updateLog) {
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
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 4.0),
            ...notes.map((note) => Text(
                  note,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: (Theme.of(context).brightness == Brightness.light)
                          ? Colors.black87
                          : Colors.white70),
                ))
          ],
        ),
      ),
    );
  }
}

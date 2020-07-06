import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
import 'package:covid19india/features/update_log/presentation/widgets/action_bar/updates.dart';
import 'package:covid19india/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActionBar extends StatefulWidget {
  final List<UpdateLog> updateLogs;
  final DateTime lastViewedTimestamp;

  ActionBar({this.updateLogs, this.lastViewedTimestamp});

  @override
  _ActionBarState createState() => _ActionBarState(
      updateLogs: this.updateLogs,
      lastViewedTimestamp: this.lastViewedTimestamp);
}

class _ActionBarState extends State<ActionBar> {
  final List<UpdateLog> updateLogs;
  final DateTime lastViewedTimestamp;

  DateTime lastUpdateTimestamp;
  bool updatesAvailable;
  bool showUpdates;

  _ActionBarState({this.updateLogs, this.lastViewedTimestamp})
      : lastUpdateTimestamp = updateLogs.last.timestamp;

  @override
  void initState() {
    super.initState();

    lastUpdateTimestamp = updateLogs.last.timestamp;

    if (lastUpdateTimestamp != lastViewedTimestamp) {
      updatesAvailable = true;
    } else {
      updatesAvailable = false;
    }

    showUpdates = false;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                new DateFormat('dd MMM, K:mm a')
                    .format(lastUpdateTimestamp.toLocal()),
                style: TextStyle(
                    fontSize: 14,
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? Colors.black87
                        : Colors.white70),
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(_bellIcon()),
                onPressed: () {
                  if (!showUpdates) {
                    sl<UpdateLogBloc>()
                      ..add(StoreLastViewedTimestampData(
                          timestamp: updateLogs.last.timestamp));
                  }

                  setState(() {
                    updatesAvailable = false;
                    showUpdates = !showUpdates;
                  });
                },
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.settings_backup_restore),
                onPressed: () {},
              ),
            ],
          ),
          if (showUpdates) Updates(updateLogs: updateLogs)
        ],
      ),
    );
  }

  IconData _bellIcon() {
    if (showUpdates) {
      return Icons.notifications_off;
    }

    return updatesAvailable ? Icons.notifications_active : Icons.notifications;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

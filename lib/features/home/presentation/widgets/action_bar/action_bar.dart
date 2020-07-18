import 'package:covid19india/features/home/presentation/widgets/action_bar/timeline.dart';
import 'package:covid19india/features/home/presentation/widgets/action_bar/updates.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum ActionBarOption { Update, Timeline, None }

class ActionBar extends StatefulWidget {
  final List<DateTime> timeline;
  final DateTime date;
  final void Function(DateTime date) setDate;

  final List<UpdateLog> updateLogs;
  final DateTime lastViewedTimestamp;

  ActionBar(
      {this.updateLogs,
      this.lastViewedTimestamp,
      this.timeline,
      this.date,
      this.setDate});

  @override
  _ActionBarState createState() => _ActionBarState(
        updateLogs: this.updateLogs,
        lastViewedTimestamp: this.lastViewedTimestamp,
        timeline: this.timeline,
        date: this.date,
      );
}

class _ActionBarState extends State<ActionBar> {
  final List<DateTime> timeline;

  final List<UpdateLog> updateLogs;
  final DateTime lastViewedTimestamp;

  ActionBarOption actionBarOption;
  DateTime lastUpdateTimestamp;
  bool updatesAvailable;

  DateTime highlightDate;

  _ActionBarState(
      {this.updateLogs,
      this.lastViewedTimestamp,
      this.timeline,
      final DateTime date})
      : lastUpdateTimestamp = updateLogs.last.timestamp,
        highlightDate = date;

  @override
  void initState() {
    super.initState();

    lastUpdateTimestamp = updateLogs.last.timestamp;

    if (lastUpdateTimestamp != lastViewedTimestamp) {
      updatesAvailable = true;
    } else {
      updatesAvailable = false;
    }

    actionBarOption = ActionBarOption.None;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildActionBarItems(),
          if (actionBarOption == ActionBarOption.Update)
            Updates(updateLogs: updateLogs),
          if (actionBarOption == ActionBarOption.Timeline)
            Timeline(
              timeline: this.timeline,
              date: highlightDate,
              setDate: (DateTime date) {
                setState(() {
                  highlightDate = date;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget buildActionBarItems() {
    if (actionBarOption == ActionBarOption.Timeline) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                actionBarOption = ActionBarOption.None;
              });
            },
            color: Colors.grey,
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              setState(() {
                actionBarOption = ActionBarOption.None;
                widget.setDate(highlightDate);
              });
            },
            color: Colors.grey,
          ),
        ],
      );
    }

    if (!widget.date.isToday()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            new DateFormat('d MMMM, yyyy').format(widget.date.toLocal()),
            style: TextStyle(
                fontSize: 14,
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.black87
                    : Colors.white70),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.settings_backup_restore),
            onPressed: () {
              setState(() {
                actionBarOption = actionBarOption == ActionBarOption.Timeline
                    ? ActionBarOption.None
                    : ActionBarOption.Timeline;
              });
            },
            color: Colors.grey,
          ),
        ],
      );
    }

    return Row(
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
          color: Colors.grey,
          onPressed: () {
            if (actionBarOption != ActionBarOption.Update) {
              context.bloc<UpdateLogBloc>().add(UpdateLastViewedTimestamp(
                  timestamp: updateLogs.last.timestamp));
            }

            setState(() {
              updatesAvailable = false;
              actionBarOption = actionBarOption == ActionBarOption.Update
                  ? ActionBarOption.None
                  : ActionBarOption.Update;
            });
          },
        ),
        SizedBox(width: 16),
        IconButton(
          icon: Icon(Icons.settings_backup_restore),
          onPressed: () {
            setState(() {
              actionBarOption = actionBarOption == ActionBarOption.Timeline
                  ? ActionBarOption.None
                  : ActionBarOption.Timeline;
            });
          },
          color: Colors.grey,
        ),
      ],
    );
  }

  IconData _bellIcon() {
    if (actionBarOption == ActionBarOption.Update) {
      return Icons.notifications_off;
    }

    return updatesAvailable ? Icons.notifications_active : Icons.notifications;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

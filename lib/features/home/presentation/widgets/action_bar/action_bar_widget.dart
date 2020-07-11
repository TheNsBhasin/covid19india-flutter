import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/features/home/presentation/widgets/action_bar/action_bar.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/time_series/bloc.dart'
    as TimeSeriesBloc;
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart'
    as UpdateLogBloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionBarWidget extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime date) setDate;

  ActionBarWidget({this.date, this.setDate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<UpdateLogBloc.UpdateLogBloc,
            UpdateLogBloc.UpdateLogState>(
          builder: (context, updateLogState) {
            if (updateLogState is UpdateLogBloc.Empty) {
              return MessageDisplay(
                message: 'Empty',
              );
            } else if (updateLogState is UpdateLogBloc.Loading) {
              return LoadingWidget(height: 50);
            } else if (updateLogState is UpdateLogBloc.Loaded) {
              return BlocBuilder<TimeSeriesBloc.TimeSeriesBloc,
                  TimeSeriesBloc.TimeSeriesState>(
                builder: (context, timeSeriesState) {
                  if (timeSeriesState is TimeSeriesBloc.Empty) {
                    return MessageDisplay(
                      message: 'Empty',
                    );
                  } else if (timeSeriesState is TimeSeriesBloc.Loading) {
                    return LoadingWidget(height: 50);
                  } else if (timeSeriesState is TimeSeriesBloc.Loaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: buildActionBar(
                          context,
                          updateLogState.updateLogs,
                          updateLogState.lastViewedTimestamp,
                          _getTimeline(timeSeriesState.timeSeries
                              .where((stateDate) => stateDate.name == 'TT')
                              .toList()
                              .first)),
                    );
                  } else if (timeSeriesState is TimeSeriesBloc.Error) {
                    return MessageDisplay(
                      message: timeSeriesState.message,
                    );
                  }

                  return Container();
                },
              );
            } else if (updateLogState is UpdateLogBloc.Error) {
              return MessageDisplay(
                message: updateLogState.message,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget buildActionBar(BuildContext context, List<UpdateLog> updateLogs,
      DateTime timestamp, List<DateTime> timeline) {
    return ActionBar(
        updateLogs: updateLogs,
        lastViewedTimestamp: timestamp,
        timeline: timeline,
        date: date,
        setDate: setDate);
  }

  List<DateTime> _getTimeline(StateWiseTimeSeries stateData) {
    return stateData.timeSeries.map((e) => e.date).toList();
  }
}

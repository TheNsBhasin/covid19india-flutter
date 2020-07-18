import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/common/widgets/loading_widget.dart';
import 'package:covid19india/core/common/widgets/message_display.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:covid19india/features/home/presentation/widgets/action_bar/action_bar.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<UpdateLogBloc, UpdateLogState>(
          builder: (context, updateLogState) {
            if (updateLogState is UpdateLogLoadInProgress) {
              return LoadingWidget(height: 50);
            } else if (updateLogState is UpdateLogLoadSuccess) {
              return BlocBuilder<TimeSeriesBloc, TimeSeriesState>(
                builder: (context, timeSeriesState) {
                  if (timeSeriesState is TimeSeriesLoadInProgress) {
                    return LoadingWidget(height: 50);
                  } else if (timeSeriesState is TimeSeriesLoadSuccess) {
                    final List<DateTime> timeline = _getTimeline(timeSeriesState
                        .timeSeries
                        .where(
                            (stateDate) => stateDate.stateCode == MapCodes.TT)
                        .toList()
                        .first);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: BlocBuilder<DateBloc, DateTime>(
                        builder: (context, date) {
                          return ActionBar(
                              updateLogs: updateLogState.updateLogs,
                              lastViewedTimestamp:
                                  updateLogState.lastViewedTimestamp,
                              timeline: timeline,
                              date: date,
                              setDate: (DateTime newDate) {
                                context
                                    .bloc<DateBloc>()
                                    .add(DateChanged(date: newDate));
                              });
                        },
                      ),
                    );
                  } else if (timeSeriesState is TimeSeriesLoadFailure) {
                    return MessageDisplay(
                      message: timeSeriesState.message,
                    );
                  }

                  return Container();
                },
              );
            } else if (updateLogState is UpdateLogLoadFailure) {
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

  List<DateTime> _getTimeline(StateTimeSeries stateData) {
    return stateData.timeSeries.map((e) => e.date).toList();
  }
}

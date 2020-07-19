import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'time_series_chart_event.dart';
part 'time_series_chart_state.dart';

class TimeSeriesChartBloc
    extends Bloc<TimeSeriesChartEvent, TimeSeriesChartState> {
  TimeSeriesChartBloc(
      {@required bool isLog,
      @required bool isUniform,
      @required TimeSeriesChartType chartType,
      @required TimeSeriesOption option})
      : super(TimeSeriesChartState(
            isLog: isLog,
            isUniform: isUniform,
            chartType: chartType,
            option: option));

  @override
  Stream<TimeSeriesChartState> mapEventToState(
    TimeSeriesChartEvent event,
  ) async* {
    if (event is TimeSeriesChartScaleChanged) {
      yield state.copyWith(isLog: event.isLog, isUniform: event.isUniform);
    } else if (event is TimeSeriesChartTypeChanged) {
      yield state.copyWith(chartType: event.chartType);
    } else if (event is TimeSeriesOptionChanged) {
      yield state.copyWith(option: event.option);
    }
  }
}

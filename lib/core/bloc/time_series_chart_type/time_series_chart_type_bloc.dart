import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/time_series_chart_type.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'time_series_chart_type_event.dart';

class TimeSeriesChartTypeBloc
    extends Bloc<TimeSeriesChartTypeEvent, TimeSeriesChartType> {
  TimeSeriesChartTypeBloc({@required TimeSeriesChartType chartType}) : super(chartType);

  @override
  Stream<TimeSeriesChartType> mapEventToState(
    TimeSeriesChartTypeEvent event,
  ) async* {
    if (event is TimeSeriesChartTypeChanged) {
      yield event.chartType;
    }
  }
}

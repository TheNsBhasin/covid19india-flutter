import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/time_series_option.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'time_series_option_event.dart';

class TimeSeriesOptionBloc
    extends Bloc<TimeSeriesOptionEvent, TimeSeriesOption> {
  TimeSeriesOptionBloc({@required TimeSeriesOption option}) : super(option);

  @override
  Stream<TimeSeriesOption> mapEventToState(
    TimeSeriesOptionEvent event,
  ) async* {
    if (event is TimeSeriesOptionChanged) {
      yield event.option;
    }
  }
}

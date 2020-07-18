import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/statistic.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'statistic_event.dart';

class StatisticBloc extends Bloc<StatisticEvent, Statistic> {
  StatisticBloc({@required Statistic statistic}) : super(statistic);

  @override
  Stream<Statistic> mapEventToState(
    StatisticEvent event,
  ) async* {
    if (event is StatisticChanged) {
      yield event.statistic;
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:covid19india/features/time_series/domain/usecases/get_state_time_series.dart';
import 'package:covid19india/features/time_series/domain/usecases/get_time_series.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'time_series_event.dart';

part 'time_series_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class TimeSeriesBloc extends Bloc<TimeSeriesEvent, TimeSeriesState> {
  final GetTimeSeries getTimeSeries;
  final GetStateTimeSeries getStateTimeSeries;

  TimeSeriesBloc(
      {@required GetTimeSeries timeSeries,
      @required GetStateTimeSeries stateTimeSeries})
      : assert(timeSeries != null),
        assert(stateTimeSeries != null),
        getTimeSeries = timeSeries,
        getStateTimeSeries = stateTimeSeries,
        super(TimeSeriesLoadInProgress());

  @override
  Stream<TimeSeriesState> mapEventToState(
    TimeSeriesEvent event,
  ) async* {
    if (event is LoadTimeSeries) {
      yield* _mapLoadTimeSeriesToState(event);
    } else if (event is UpdateTimeSeries) {
      yield* _mapUpdateTimeSeriesToState(event);
    }
  }

  Stream<TimeSeriesState> _mapLoadTimeSeriesToState(
      LoadTimeSeries event) async* {
    try {
      yield TimeSeriesLoadInProgress();
      final failureOrTimeSeries = await this.getTimeSeries(
          GetTimeSeriesParams(forced: event.forced, cache: event.cache));
      yield* _eitherLoadedOrErrorState(failureOrTimeSeries);
    } catch (_) {
      yield TimeSeriesLoadFailure();
    }
  }

  Stream<TimeSeriesState> _mapUpdateTimeSeriesToState(
      UpdateTimeSeries event) async* {
    try {
      List<StateTimeSeries> oldTimeSeries = (state is TimeSeriesLoadSuccess)
          ? (state as TimeSeriesLoadSuccess).timeSeries
          : <StateTimeSeries>[];

      yield TimeSeriesLoadInProgress();
      final failureOrTimeSeries = await this.getStateTimeSeries(
          GetStateTimeSeriesParams(
              forced: event.forced,
              cache: event.cache,
              stateCode: event.mapCode));
      yield* _eitherUpdatedOrErrorState(oldTimeSeries, failureOrTimeSeries);
    } catch (_) {
      yield TimeSeriesLoadFailure();
    }
  }

  Stream<TimeSeriesState> _eitherLoadedOrErrorState(
      Either<Failure, List<StateTimeSeries>> failureOrTimeSeries) async* {
    yield failureOrTimeSeries.fold(
      (failure) =>
          TimeSeriesLoadFailure(message: _mapFailureToMessage(failure)),
      (timeSeries) => TimeSeriesLoadSuccess(timeSeries),
    );
  }

  Stream<TimeSeriesState> _eitherUpdatedOrErrorState(
      List<StateTimeSeries> oldTimeSeries, failureOrTimeSeries) async* {
    yield failureOrTimeSeries.fold(
      (failure) =>
          TimeSeriesLoadFailure(message: _mapFailureToMessage(failure)),
      (timeSeries) => TimeSeriesLoadSuccess((oldTimeSeries.length > 0)
          ? oldTimeSeries
              .map((e) => e.stateCode == timeSeries.stateCode ? timeSeries : e)
              .toList()
              .cast<StateTimeSeries>()
          : <StateTimeSeries>[timeSeries]),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}

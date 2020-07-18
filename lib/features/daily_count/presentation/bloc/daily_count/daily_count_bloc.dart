import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/usecases/get_daily_count.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'daily_count_event.dart';

part 'daily_count_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class DailyCountBloc extends Bloc<DailyCountEvent, DailyCountState> {
  final GetDailyCount getDailyCount;

  DailyCountBloc({@required GetDailyCount dailyCount})
      : assert(dailyCount != null),
        getDailyCount = dailyCount,
        super(DailyCountLoadInProgress());

  @override
  Stream<DailyCountState> mapEventToState(
    DailyCountEvent event,
  ) async* {
    if (event is LoadDailyCount) {
      yield* _mapLoadDailyCountToState(event);
    }
  }

  Stream<DailyCountState> _mapLoadDailyCountToState(
      LoadDailyCount event) async* {
    try {
      yield DailyCountLoadInProgress();
      final failureOrDailyCounts = await this.getDailyCount(DailyCountParams(
          forced: event.forced, cache: event.cache, date: event.date));
      yield* _eitherLoadedOrErrorState(failureOrDailyCounts);
    } catch (_) {
      yield DailyCountLoadFailure(message: _.toString());
    }
  }

  Stream<DailyCountState> _eitherLoadedOrErrorState(
      Either<Failure, List<StateDailyCount>> failureOrDailyCounts) async* {
    yield failureOrDailyCounts.fold(
      (failure) =>
          DailyCountLoadFailure(message: _mapFailureToMessage(failure)),
      (dailyCounts) => DailyCountLoadSuccess(dailyCounts),
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

import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/usecases/get_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/daily_count_event.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/daily_count_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class DailyCountBloc extends Bloc<DailyCountEvent, DailyCountState> {
  final GetDailyCount getDailyCount;

  DailyCountBloc({@required GetDailyCount dailyCount})
      : assert(dailyCount != null),
        getDailyCount = dailyCount;

  @override
  DailyCountState get initialState => Empty();

  @override
  Stream<DailyCountState> mapEventToState(DailyCountEvent event) async* {
    print(event);

    if (event is GetDailyCountData) {
      yield Loading();
      final failureOrDailyCounts = await getDailyCount(
          Params(forced: event.forced, cache: event.cache, date: event.date));
      yield* _eitherLoadedOrErrorState(failureOrDailyCounts);
    }
  }

  Stream<DailyCountState> _eitherLoadedOrErrorState(
    Either<Failure, List<StateWiseDailyCount>> failureOrDailyCounts,
  ) async* {
    yield failureOrDailyCounts.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (dailyCounts) => Loaded(dailyCounts: dailyCounts),
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

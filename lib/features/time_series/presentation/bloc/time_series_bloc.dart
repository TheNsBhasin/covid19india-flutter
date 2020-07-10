import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/domain/usecases/get_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/time_series_event.dart';
import 'package:covid19india/features/time_series/presentation/bloc/time_series_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class TimeSeriesBloc extends Bloc<TimeSeriesEvent, TimeSeriesState> {
  final GetTimeSeries getTimeSeries;

  TimeSeriesBloc({@required GetTimeSeries timeSeries})
      : assert(timeSeries != null),
        getTimeSeries = timeSeries;

  @override
  TimeSeriesState get initialState => Empty();

  @override
  Stream<TimeSeriesState> mapEventToState(TimeSeriesEvent event) async* {
    print(event);

    if (event is GetTimeSeriesData) {
      yield Loading();
      final failureOrTimeSeries = await getTimeSeries(
          Params(forced: event.forced));
      yield* _eitherLoadedOrErrorState(failureOrTimeSeries);
    }
  }

  Stream<TimeSeriesState> _eitherLoadedOrErrorState(
    Either<Failure, List<StateWiseTimeSeries>> failureOrTimeSeries,
  ) async* {
    yield failureOrTimeSeries.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (timeSeries) => Loaded(timeSeries: timeSeries),
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

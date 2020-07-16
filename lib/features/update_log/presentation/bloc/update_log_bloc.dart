import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/usecases/usecase.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:covid19india/features/update_log/domain/usecases/get_last_viewed_timestamp.dart';
import 'package:covid19india/features/update_log/domain/usecases/get_update_logs.dart';
import 'package:covid19india/features/update_log/domain/usecases/store_last_viewed_timestamp.dart';
import 'package:covid19india/features/update_log/presentation/bloc/update_log_event.dart';
import 'package:covid19india/features/update_log/presentation/bloc/update_log_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class UpdateLogBloc extends Bloc<UpdateLogEvent, UpdateLogState> {
  final GetUpdateLogs getUpdateLogs;
  final GetLastViewedTimestamp getLastViewedTimestamp;
  final StoreLastViewedTimestamp storeLastViewedTimestamp;

  UpdateLogBloc(
      {@required GetUpdateLogs updateLogs,
      @required GetLastViewedTimestamp lastViewedTimestamp,
      @required StoreLastViewedTimestamp storeLastViewedTimestamp})
      : assert(updateLogs != null),
        assert(lastViewedTimestamp != null),
        assert(storeLastViewedTimestamp != null),
        getUpdateLogs = updateLogs,
        getLastViewedTimestamp = lastViewedTimestamp,
        storeLastViewedTimestamp = storeLastViewedTimestamp;

  @override
  UpdateLogState get initialState => Empty();

  @override
  Stream<UpdateLogState> mapEventToState(UpdateLogEvent event) async* {
    print('UpdateLogBloc: $event');

    if (event is GetUpdateLogData) {
      yield Loading();
      final failureOrUpdateLogs =
          await getUpdateLogs(GetUpdateLogsParams(forced: event.forced));
      final failureOrLastViewedTimestamp =
          await getLastViewedTimestamp(NoParams());
      yield* _eitherLoadedOrErrorState(
          failureOrUpdateLogs, failureOrLastViewedTimestamp);
    }

    if (event is StoreLastViewedTimestampData) {
      await storeLastViewedTimestamp(
          StoreLastViewedTimestampParams(timestamp: event.timestamp));
    }
  }

  Stream<UpdateLogState> _eitherLoadedOrErrorState(
      Either<Failure, List<UpdateLog>> failureOrUpdateLogs,
      Either<Failure, DateTime> failureOrLastViewedTimestamp) async* {
    yield failureOrUpdateLogs.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (updateLogs) => failureOrLastViewedTimestamp.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (timestamp) => Loaded(
                updateLogs: updateLogs, lastViewedTimestamp: timestamp)));
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

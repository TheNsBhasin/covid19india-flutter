import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/usecases/usecase.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:covid19india/features/update_log/domain/usecases/get_last_viewed_timestamp.dart';
import 'package:covid19india/features/update_log/domain/usecases/get_update_logs.dart';
import 'package:covid19india/features/update_log/domain/usecases/store_last_viewed_timestamp.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'update_log_event.dart';
part 'update_log_state.dart';

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
        storeLastViewedTimestamp = storeLastViewedTimestamp,
        super(UpdateLogLoadInProgress());

  @override
  Stream<UpdateLogState> mapEventToState(
    UpdateLogEvent event,
  ) async* {
    if (event is LoadUpdateLog) {
      yield* _mapLoadUpdateLogToState(event);
    } else if (event is UpdateLastViewedTimestamp) {
      yield* _mapUpdateLastViewedTimestampToState(event);
    }
  }

  Stream<UpdateLogState> _mapLoadUpdateLogToState(LoadUpdateLog event) async* {
    final failureOrUpdateLogs =
        await getUpdateLogs(GetUpdateLogsParams(forced: event.forced));

    final failureOrLastViewedTimestamp =
        await getLastViewedTimestamp(NoParams());

    yield* _eitherLoadedOrErrorState(
        failureOrUpdateLogs, failureOrLastViewedTimestamp);
  }

  Stream<UpdateLogState> _mapUpdateLastViewedTimestampToState(
      UpdateLastViewedTimestamp event) async* {
    await storeLastViewedTimestamp(
        StoreLastViewedTimestampParams(timestamp: event.timestamp));

    if (state is UpdateLogLoadSuccess) {
      yield UpdateLogLoadSuccess(
          updateLogs: (state as UpdateLogLoadSuccess).updateLogs,
          lastViewedTimestamp: event.timestamp);
    }
  }

  Stream<UpdateLogState> _eitherLoadedOrErrorState(
      Either<Failure, List<UpdateLog>> failureOrUpdateLogs,
      Either<Failure, DateTime> failureOrLastViewedTimestamp) async* {
    yield failureOrUpdateLogs.fold(
        (failure) =>
            UpdateLogLoadFailure(message: _mapFailureToMessage(failure)),
        (updateLogs) => failureOrLastViewedTimestamp.fold(
            (failure) =>
                UpdateLogLoadFailure(message: _mapFailureToMessage(failure)),
            (timestamp) => UpdateLogLoadSuccess(
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

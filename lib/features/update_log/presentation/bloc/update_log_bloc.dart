import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:covid19india/features/update_log/domain/usecases/get_update_logs.dart';
import 'package:covid19india/features/update_log/presentation/bloc/update_log_event.dart';
import 'package:covid19india/features/update_log/presentation/bloc/update_log_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class UpdateLogBloc extends Bloc<UpdateLogEvent, UpdateLogState> {
  final GetUpdateLogs getUpdateLogs;

  UpdateLogBloc({@required GetUpdateLogs updateLogs})
      : assert(updateLogs != null),
        getUpdateLogs = updateLogs;

  @override
  UpdateLogState get initialState => Empty();

  @override
  Stream<UpdateLogState> mapEventToState(UpdateLogEvent event) async* {
    if (event is GetUpdateLogData) {
      yield Loading();
      final failureOrUpdateLogs =
          await getUpdateLogs(Params(forced: event.forced));
      yield* _eitherLoadedOrErrorState(failureOrUpdateLogs);
    }
  }

  Stream<UpdateLogState> _eitherLoadedOrErrorState(
    Either<Failure, List<UpdateLog>> failureOrUpdateLogs,
  ) async* {
    yield failureOrUpdateLogs.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (updateLogs) => Loaded(updateLogs: updateLogs),
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

part of 'update_log_bloc.dart';

abstract class UpdateLogState extends Equatable {
  const UpdateLogState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class UpdateLogLoadInProgress extends UpdateLogState {}

class UpdateLogLoadSuccess extends UpdateLogState {
  final List<UpdateLog> updateLogs;
  final DateTime lastViewedTimestamp;

  const UpdateLogLoadSuccess({this.updateLogs, this.lastViewedTimestamp});

  @override
  List<Object> get props => [updateLogs, lastViewedTimestamp];
}

class UpdateLogLoadFailure extends UpdateLogState {
  final String message;

  UpdateLogLoadFailure({this.message});
}

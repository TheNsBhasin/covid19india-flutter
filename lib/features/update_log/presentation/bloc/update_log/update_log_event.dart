part of 'update_log_bloc.dart';

abstract class UpdateLogEvent extends Equatable {
  const UpdateLogEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadUpdateLog extends UpdateLogEvent {
  final bool forced;

  LoadUpdateLog({this.forced: false});

  @override
  List<Object> get props => [forced];
}

class UpdateLastViewedTimestamp extends UpdateLogEvent {
  final DateTime timestamp;

  UpdateLastViewedTimestamp({this.timestamp});

  @override
  List<Object> get props => [timestamp];
}

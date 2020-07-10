import 'package:equatable/equatable.dart';

abstract class UpdateLogEvent extends Equatable {}

class GetUpdateLogData extends UpdateLogEvent {
  final bool forced;

  GetUpdateLogData({this.forced = false});

  @override
  List<Object> get props => [forced];

  @override
  String toString() {
    return 'GetUpdateLogData {forced: $forced}';
  }
}

class StoreLastViewedTimestampData extends UpdateLogEvent {
  final DateTime timestamp;

  StoreLastViewedTimestampData({this.timestamp});

  @override
  List<Object> get props => [timestamp];

  @override
  String toString() {
    return 'StoreLastViewedTimestampData {timestamp: $timestamp}';
  }
}

import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class UpdateLogState extends Equatable {}

class Empty extends UpdateLogState {
  @override
  List<Object> get props => [];
}

class Loading extends UpdateLogState {
  @override
  List<Object> get props => [];
}

class Loaded extends UpdateLogState {
  final List<UpdateLog> updateLogs;
  final DateTime lastViewedTimestamp;

  Loaded({this.updateLogs, this.lastViewedTimestamp});

  @override
  List<Object> get props => [updateLogs, lastViewedTimestamp];
}

class Error extends UpdateLogState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}

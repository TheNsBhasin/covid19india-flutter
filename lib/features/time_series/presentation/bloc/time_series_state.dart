import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TimeSeriesState extends Equatable {}

class Empty extends TimeSeriesState {
  @override
  List<Object> get props => [];
}

class Loading extends TimeSeriesState {
  @override
  List<Object> get props => [];
}

class Loaded extends TimeSeriesState {
  final List<StateWiseTimeSeries> timeSeries;

  Loaded({this.timeSeries});

  @override
  List<Object> get props => [timeSeries];
}

class Error extends TimeSeriesState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}

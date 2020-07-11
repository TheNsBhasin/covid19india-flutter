import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class StateTimeSeriesState extends Equatable {}

class Empty extends StateTimeSeriesState {
  @override
  List<Object> get props => [];
}

class Loading extends StateTimeSeriesState {
  @override
  List<Object> get props => [];
}

class Loaded extends StateTimeSeriesState {
  final StateWiseTimeSeries timeSeries;

  Loaded({this.timeSeries});

  @override
  List<Object> get props => [timeSeries];
}

class Error extends StateTimeSeriesState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}

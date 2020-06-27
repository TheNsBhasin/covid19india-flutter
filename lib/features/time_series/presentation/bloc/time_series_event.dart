import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TimeSeriesEvent extends Equatable {}

class GetTimeSeriesData extends TimeSeriesEvent {
  final bool forced;

  GetTimeSeriesData({this.forced: false});

  @override
  List<Object> get props => [];
}

import 'package:covid19india/features/time_series/domain/entities/district_wise_time_series.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class StateWiseTimeSeries extends Equatable {
  final String name;
  final List<TimeSeries> timeSeries;
  final List<DistrictWiseTimeSeries> districts;

  StateWiseTimeSeries(
      {@required this.name, @required this.timeSeries, this.districts});

  @override
  List<Object> get props => [name, timeSeries, districts];

  @override
  bool get stringify => true;
}

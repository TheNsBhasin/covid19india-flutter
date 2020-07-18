import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/features/time_series/domain/entities/district_time_series.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class StateTimeSeries extends Equatable {
  final MapCodes stateCode;
  final List<TimeSeries> timeSeries;
  final List<DistrictTimeSeries> districts;

  StateTimeSeries(
      {@required this.stateCode,
      @required this.timeSeries,
      @required this.districts});

  @override
  List<Object> get props => [stateCode, timeSeries, districts];

  @override
  bool get stringify => true;
}

import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class DistrictWiseTimeSeries extends Equatable {
  final String name;
  final List<TimeSeries> timeSeries;

  DistrictWiseTimeSeries({@required this.name, @required this.timeSeries});

  @override
  List<Object> get props => [name, timeSeries];

  @override
  bool get stringify => true;
}

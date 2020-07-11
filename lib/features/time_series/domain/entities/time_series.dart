import 'package:covid19india/core/entity/stats.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class TimeSeries extends Equatable {
  final DateTime date;
  final Stats total;
  final Stats delta;

  TimeSeries({@required this.date, @required this.total, @required this.delta});

  @override
  List<Object> get props => [date, total, delta];

  @override
  bool get stringify => true;
}

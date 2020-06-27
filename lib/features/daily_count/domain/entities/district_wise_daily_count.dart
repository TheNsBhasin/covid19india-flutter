import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class DistrictWiseDailyCount extends Equatable {
  final String name;
  final Stats total;
  final Stats delta;

  DistrictWiseDailyCount(
      {@required this.name, @required this.total, @required this.delta});

  @override
  List<Object> get props => [name, total, delta];

  @override
  bool get stringify => true;
}

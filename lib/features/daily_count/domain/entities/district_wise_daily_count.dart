import 'package:covid19india/features/daily_count/domain/entities/metadata.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class DistrictWiseDailyCount extends Equatable {
  final String name;
  final Stats total;
  final Stats delta;
  final Metadata metadata;

  DistrictWiseDailyCount(
      {@required this.name,
      @required this.total,
      @required this.delta,
      @required this.metadata});

  @override
  List<Object> get props => [name, total, delta, metadata];

  @override
  bool get stringify => true;
}

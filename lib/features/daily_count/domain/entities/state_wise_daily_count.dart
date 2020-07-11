import 'package:covid19india/core/entity/stats.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/metadata.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class StateWiseDailyCount extends Equatable {
  final String name;
  final Stats total;
  final Stats delta;
  final Metadata metadata;
  final List<DistrictWiseDailyCount> districts;

  StateWiseDailyCount(
      {@required this.name,
      @required this.total,
      @required this.delta,
      @required this.metadata,
      @required this.districts});

  @override
  List<Object> get props => [name, total, delta, metadata, districts];

  @override
  bool get stringify => true;
}

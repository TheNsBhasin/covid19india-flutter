import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/stats.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/metadata.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class StateDailyCount extends Equatable {
  final MapCodes stateCode;
  final Stats total;
  final Stats delta;
  final Metadata metadata;
  final List<DistrictDailyCount> districts;

  StateDailyCount(
      {@required this.stateCode,
      @required this.total,
      @required this.delta,
      @required this.metadata,
      @required this.districts});

  @override
  List<Object> get props => [stateCode, total, delta, metadata, districts];

  @override
  bool get stringify => true;
}

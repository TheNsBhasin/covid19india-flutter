import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/model/stats_model.dart';
import 'package:covid19india/features/daily_count/data/models/district_daily_count_model.dart';
import 'package:covid19india/features/daily_count/data/models/metadata_model.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';

class StateDailyCountModel extends StateDailyCount {
  StateDailyCountModel(
      {MapCodes stateCode,
      StatsModel total,
      StatsModel delta,
      MetadataModel metadata,
      List<DistrictDailyCountModel> districts})
      : super(
            stateCode: stateCode,
            total: total.toEntity(),
            delta: delta.toEntity(),
            metadata: metadata.toEntity(),
            districts: districts.map((e) => e.toEntity()).toList());

  StateDailyCountModel copyWith(
      {MapCodes stateCode,
      StatsModel total,
      StatsModel delta,
      MetadataModel metadata,
      List<DistrictDailyCountModel> districts}) {
    return StateDailyCountModel(
      stateCode: stateCode ?? this.stateCode,
      total: total.toEntity() ?? this.total,
      delta: delta.toEntity() ?? this.delta,
      metadata: metadata.toEntity() ?? this.metadata,
      districts: districts.map((e) => e.toEntity()).toList() ?? this.districts,
    );
  }

  factory StateDailyCountModel.fromEntity(StateDailyCount entity) {
    return StateDailyCountModel(
        stateCode: entity.stateCode,
        total: StatsModel.fromEntity(entity.total),
        delta: StatsModel.fromEntity(entity.delta),
        metadata: MetadataModel.fromEntity(entity.metadata),
        districts: entity.districts
            .map((e) => DistrictDailyCountModel.fromEntity(e))
            .toList()
            .cast<DistrictDailyCountModel>());
  }

  StateDailyCount toEntity() {
    return StateDailyCount(
        stateCode: this.stateCode,
        total: this.total,
        delta: this.delta,
        metadata: this.metadata,
        districts: this.districts);
  }

  factory StateDailyCountModel.fromJson(Map<String, dynamic> json) {
    return StateDailyCountModel(
        stateCode: (json['state_code'] as String).toMapCode(),
        total: StatsModel.fromJson(json['total']),
        delta: StatsModel.fromJson(json['delta']),
        metadata: MetadataModel.fromJson(json['metadata']),
        districts: json["districts"]
            .map((district) => DistrictDailyCountModel.fromJson(district))
            .toList()
            .cast<DistrictDailyCountModel>());
  }

  Map<String, dynamic> toJson() {
    return {
      'state_code': stateCode.key,
      'total': StatsModel.fromEntity(total).toJson(),
      'delta': StatsModel.fromEntity(delta).toJson(),
      'metadata': MetadataModel.fromEntity(metadata).toJson(),
      'districts': districts
          .map((district) =>
              DistrictDailyCountModel.fromEntity(district).toJson())
          .toList()
    };
  }
}

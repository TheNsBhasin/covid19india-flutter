import 'package:covid19india/core/model/stats_model.dart';
import 'package:covid19india/features/daily_count/data/models/metadata_model.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_daily_count.dart';

class DistrictDailyCountModel extends DistrictDailyCount {
  DistrictDailyCountModel({
    String name,
    StatsModel total,
    StatsModel delta,
    MetadataModel metadata,
  }) : super(
            name: name,
            total: total.toEntity(),
            delta: delta.toEntity(),
            metadata: metadata.toEntity());

  DistrictDailyCountModel copyWith(
      {String name,
      StatsModel total,
      StatsModel delta,
      MetadataModel metadata}) {
    return DistrictDailyCountModel(
      name: name ?? this.name,
      total: total.toEntity() ?? this.total,
      delta: delta.toEntity() ?? this.delta,
      metadata: metadata.toEntity() ?? this.metadata,
    );
  }

  factory DistrictDailyCountModel.fromEntity(DistrictDailyCount entity) {
    return DistrictDailyCountModel(
      name: entity.name,
      total: StatsModel.fromEntity(entity.total),
      delta: StatsModel.fromEntity(entity.delta),
      metadata: MetadataModel.fromEntity(entity.metadata),
    );
  }

  DistrictDailyCount toEntity() {
    return DistrictDailyCount(
      name: this.name,
      total: this.total,
      delta: this.delta,
      metadata: this.metadata,
    );
  }

  factory DistrictDailyCountModel.fromJson(Map<String, dynamic> json) {
    return DistrictDailyCountModel(
        name: json['name'],
        total: StatsModel.fromJson(json['total']),
        delta: StatsModel.fromJson(json['delta']),
        metadata: MetadataModel.fromJson(json['metadata']));
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total': StatsModel.fromEntity(total).toJson(),
      'delta': StatsModel.fromEntity(delta).toJson(),
      'metadata': MetadataModel.fromEntity(metadata).toJson()
    };
  }
}

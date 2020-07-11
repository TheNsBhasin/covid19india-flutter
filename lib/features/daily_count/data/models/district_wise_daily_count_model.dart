import 'package:covid19india/core/model/stats_model.dart';
import 'package:covid19india/features/daily_count/data/models/metadata_model.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';

class DistrictWiseDailyCountModel extends DistrictWiseDailyCount {
  DistrictWiseDailyCountModel(
      {String name, StatsModel total, StatsModel delta, MetadataModel metadata})
      : super(name: name, total: total, delta: delta, metadata: metadata);

  factory DistrictWiseDailyCountModel.fromJson(Map<String, dynamic> json) {
    return DistrictWiseDailyCountModel(
        name: json['name'],
        total: StatsModel.fromJson(json['total']),
        delta: StatsModel.fromJson(json['delta']),
        metadata: MetadataModel.fromJson(json['metadata']));
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total': StatsModel(
        confirmed: total.confirmed,
        recovered: total.recovered,
        deceased: total.deceased,
      ).toJson(),
      'delta': StatsModel(
        confirmed: delta.confirmed,
        recovered: delta.recovered,
        deceased: delta.deceased,
      ).toJson(),
      'metadata': MetadataModel(
              lastUpdated: metadata.lastUpdated,
              population: metadata.population,
              notes: metadata.notes,
              tested: metadata.tested)
          .toJson()
    };
  }
}

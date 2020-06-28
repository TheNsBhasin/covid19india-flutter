import 'package:covid19india/features/daily_count/data/models/district_wise_daily_count_model.dart';
import 'package:covid19india/features/daily_count/data/models/metadata_model.dart';
import 'package:covid19india/features/daily_count/data/models/stats_model.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';

class StateWiseDailyCountModel extends StateWiseDailyCount {
  StateWiseDailyCountModel(
      {String name,
      StatsModel total,
      StatsModel delta,
      MetadataModel metadata,
      List<DistrictWiseDailyCount> districts})
      : super(
            name: name,
            total: total,
            delta: delta,
            metadata: metadata,
            districts: districts);

  factory StateWiseDailyCountModel.fromJson(Map<String, dynamic> json) {
    return StateWiseDailyCountModel(
        name: json['name'],
        total: StatsModel.fromJson(json['total']),
        delta: StatsModel.fromJson(json['delta']),
        metadata: MetadataModel.fromJson(json['metadata']),
        districts: json["districts"]
            .map((district) => DistrictWiseDailyCountModel.fromJson(district))
            .toList()
            .cast<DistrictWiseDailyCountModel>());
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total': StatsModel(
              confirmed: total.confirmed,
              recovered: total.recovered,
              deceased: total.deceased,
              tested: total.tested)
          .toJson(),
      'delta': StatsModel(
              confirmed: delta.confirmed,
              recovered: delta.recovered,
              deceased: delta.deceased,
              tested: delta.tested)
          .toJson(),
      'metadata': MetadataModel(
              lastUpdated: metadata.lastUpdated,
              notes: metadata.notes,
              tested: metadata.tested)
          .toJson(),
      'districts': districts
          .map((district) => DistrictWiseDailyCountModel(
              name: district.name,
              total: StatsModel(
                confirmed: district.total.confirmed,
                recovered: district.total.recovered,
                deceased: district.total.deceased,
                tested: district.total.tested,
              ),
              delta: StatsModel(
                confirmed: district.delta.confirmed,
                recovered: district.delta.recovered,
                deceased: district.delta.deceased,
                tested: district.total.tested,
              )).toJson())
          .toList()
    };
  }
}
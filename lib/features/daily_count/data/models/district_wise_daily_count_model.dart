import 'package:covid19india/features/daily_count/data/models/stats_model.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';

class DistrictWiseDailyCountModel extends DistrictWiseDailyCount {
  DistrictWiseDailyCountModel({String name, StatsModel total, StatsModel delta})
      : super(name: name, total: total, delta: delta);

  factory DistrictWiseDailyCountModel.fromJson(Map<String, dynamic> json) {
    return DistrictWiseDailyCountModel(
        name: json['name'],
        total: StatsModel.fromJson(json['total']),
        delta: StatsModel.fromJson(json['delta']));
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
      ).toJson()
    };
  }
}
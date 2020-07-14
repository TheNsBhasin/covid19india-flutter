import 'package:covid19india/core/model/stats_model.dart';
import 'package:covid19india/features/time_series/data/models/district_wise_time_series_model.dart';
import 'package:covid19india/features/time_series/data/models/time_series_model.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';

class StateWiseTimeSeriesModel extends StateWiseTimeSeries {
  StateWiseTimeSeriesModel(
      {String name,
      List<TimeSeriesModel> timeSeries,
      List<DistrictWiseTimeSeriesModel> districts})
      : super(name: name, timeSeries: timeSeries, districts: districts);

  factory StateWiseTimeSeriesModel.fromJson(Map<String, dynamic> json) {
    return StateWiseTimeSeriesModel(
        name: json['name'],
        timeSeries: (json["time_series"] ?? [])
            .map((series) => TimeSeriesModel.fromJson(series))
            .toList()
            .cast<TimeSeriesModel>(),
        districts: (json["districts"] ?? [])
            .map((district) => DistrictWiseTimeSeriesModel.fromJson(district))
            .toList()
            .cast<DistrictWiseTimeSeriesModel>());
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time_series': timeSeries
          .map((series) => TimeSeriesModel(
                  date: series.date,
                  total: StatsModel(
                      confirmed: series.total.confirmed,
                      recovered: series.total.recovered,
                      deceased: series.total.deceased,
                      tested: series.total.tested,
                      migrated: series.total.migrated),
                  delta: StatsModel(
                      confirmed: series.delta.confirmed,
                      recovered: series.delta.recovered,
                      deceased: series.delta.deceased,
                      tested: series.delta.tested,
                      migrated: series.delta.migrated))
              .toJson())
          .toList(),
      'districts': districts
          .map((districtData) => DistrictWiseTimeSeriesModel(
              name: districtData.name,
              timeSeries: districtData.timeSeries.map((series) =>
                  TimeSeriesModel(
                      date: series.date,
                      total: StatsModel(
                          confirmed: series.total.confirmed,
                          recovered: series.total.recovered,
                          deceased: series.total.deceased,
                          tested: series.total.tested,
                          migrated: series.total.migrated),
                      delta: StatsModel(
                          confirmed: series.delta.confirmed,
                          recovered: series.delta.recovered,
                          deceased: series.delta.deceased,
                          tested: series.delta.tested,
                          migrated: series.delta.migrated))).toList()).toJson())
          .toList()
    };
  }
}

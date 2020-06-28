import 'package:covid19india/features/time_series/data/models/stats_model.dart';
import 'package:covid19india/features/time_series/data/models/time_series_model.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';

class StateWiseTimeSeriesModel extends StateWiseTimeSeries {
  StateWiseTimeSeriesModel({String name, List<TimeSeriesModel> timeSeries})
      : super(name: name, timeSeries: timeSeries);

  factory StateWiseTimeSeriesModel.fromJson(Map<String, dynamic> json) {
    return StateWiseTimeSeriesModel(
        name: json['name'],
        timeSeries: (json["time_series"] ?? [])
            .map((series) => TimeSeriesModel.fromJson(series))
            .toList()
            .cast<TimeSeriesModel>());
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
                      tested: series.total.tested),
                  delta: StatsModel(
                      confirmed: series.delta.confirmed,
                      recovered: series.delta.recovered,
                      deceased: series.delta.deceased,
                      tested: series.delta.tested))
              .toJson())
          .toList()
    };
  }
}
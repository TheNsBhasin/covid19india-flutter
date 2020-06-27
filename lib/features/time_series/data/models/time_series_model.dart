import 'package:covid19india/features/time_series/data/models/stats_model.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:intl/intl.dart';

class TimeSeriesModel extends TimeSeries {
  TimeSeriesModel({DateTime date, StatsModel total, StatsModel delta})
      : super(date: date, total: total, delta: delta);

  factory TimeSeriesModel.fromJson(Map<String, dynamic> json) {
    return TimeSeriesModel(
        date: DateTime.parse(json['date']),
        total: StatsModel.fromJson(json['total']),
        delta: StatsModel.fromJson(json['delta']));
  }

  Map<String, dynamic> toJson() {
    return {
      'date': DateFormat('yyyy-MM-dd').format(date),
      'total': StatsModel(
        confirmed: total.confirmed,
        recovered: total.recovered,
        deceased: total.deceased,
        tested: total.tested
      ).toJson(),
      'delta': StatsModel(
        confirmed: delta.confirmed,
        recovered: delta.recovered,
        deceased: delta.deceased,
        tested: delta.tested
      ).toJson()
    };
  }
}

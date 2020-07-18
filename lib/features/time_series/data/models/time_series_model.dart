import 'package:covid19india/core/model/stats_model.dart';
import 'package:covid19india/features/time_series/domain/entities/time_series.dart';
import 'package:intl/intl.dart';

class TimeSeriesModel extends TimeSeries {
  TimeSeriesModel({
    DateTime date,
    StatsModel total,
    StatsModel delta,
  }) : super(date: date, total: total.toEntity(), delta: delta.toEntity());

  TimeSeriesModel copyWith({
    DateTime date,
    StatsModel total,
    StatsModel delta,
  }) {
    return TimeSeriesModel(
      date: date ?? this.date,
      total: total.toEntity() ?? this.total,
      delta: delta.toEntity() ?? this.delta,
    );
  }

  factory TimeSeriesModel.fromEntity(TimeSeries entity) {
    return TimeSeriesModel(
      date: entity.date,
      total: StatsModel.fromEntity(entity.total),
      delta: StatsModel.fromEntity(entity.delta),
    );
  }

  TimeSeries toEntity() {
    return TimeSeries(date: date, total: total, delta: delta);
  }

  factory TimeSeriesModel.fromJson(Map<String, dynamic> json) {
    return TimeSeriesModel(
        date: DateTime.parse(json['date']),
        total: StatsModel.fromJson(json['total']),
        delta: StatsModel.fromJson(json['delta']));
  }

  Map<String, dynamic> toJson() {
    return {
      'date': DateFormat('yyyy-MM-dd').format(date),
      'total': StatsModel.fromEntity(total).toJson(),
      'delta': StatsModel.fromEntity(delta).toJson(),
    };
  }
}

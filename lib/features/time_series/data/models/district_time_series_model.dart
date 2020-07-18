import 'package:covid19india/features/time_series/data/models/time_series_model.dart';
import 'package:covid19india/features/time_series/domain/entities/district_time_series.dart';

class DistrictTimeSeriesModel extends DistrictTimeSeries {
  DistrictTimeSeriesModel({
    String name,
    List<TimeSeriesModel> timeSeries,
  }) : super(
            name: name,
            timeSeries: timeSeries.map((e) => e.toEntity()).toList());

  DistrictTimeSeriesModel copyWith({
    String name,
    List<TimeSeriesModel> timeSeries,
  }) {
    return DistrictTimeSeriesModel(
      name: name ?? this.name,
      timeSeries:
          timeSeries.map((e) => e.toEntity()).toList() ?? this.timeSeries,
    );
  }

  factory DistrictTimeSeriesModel.fromEntity(DistrictTimeSeries entity) {
    return DistrictTimeSeriesModel(
      name: entity.name,
      timeSeries: entity.timeSeries
          .map((e) => TimeSeriesModel.fromEntity(e))
          .toList()
          .cast<TimeSeriesModel>(),
    );
  }

  DistrictTimeSeries toEntity() {
    return DistrictTimeSeries(name: name, timeSeries: timeSeries);
  }

  factory DistrictTimeSeriesModel.fromJson(Map<String, dynamic> json) {
    return DistrictTimeSeriesModel(
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
          .map((series) => TimeSeriesModel.fromEntity(series).toJson())
          .toList()
    };
  }
}

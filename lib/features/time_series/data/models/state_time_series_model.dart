import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/features/time_series/data/models/district_time_series_model.dart';
import 'package:covid19india/features/time_series/data/models/time_series_model.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';

class StateTimeSeriesModel extends StateTimeSeries {
  StateTimeSeriesModel({
    MapCodes stateCode,
    List<TimeSeriesModel> timeSeries,
    List<DistrictTimeSeriesModel> districts,
  }) : super(
            stateCode: stateCode,
            timeSeries: timeSeries.map((e) => e.toEntity()).toList(),
            districts: districts.map((e) => e.toEntity()).toList());

  StateTimeSeriesModel copyWith({
    MapCodes stateCode,
    List<TimeSeriesModel> timeSeries,
    List<DistrictTimeSeriesModel> districts,
  }) {
    return StateTimeSeriesModel(
        stateCode: stateCode ?? this.stateCode,
        timeSeries:
            timeSeries.map((e) => e.toEntity()).toList() ?? this.timeSeries,
        districts:
            districts.map((e) => e.toEntity()).toList() ?? this.districts);
  }

  factory StateTimeSeriesModel.fromEntity(StateTimeSeries entity) {
    return StateTimeSeriesModel(
      stateCode: entity.stateCode,
      timeSeries: entity.timeSeries
          .map((e) => TimeSeriesModel.fromEntity(e))
          .toList()
          .cast<TimeSeriesModel>(),
      districts: entity.districts
          .map((e) => DistrictTimeSeriesModel.fromEntity(e))
          .toList()
          .cast<DistrictTimeSeriesModel>(),
    );
  }

  StateTimeSeries toEntity() {
    return StateTimeSeries(
      stateCode: stateCode,
      timeSeries: timeSeries,
      districts: districts,
    );
  }

  factory StateTimeSeriesModel.fromJson(Map<String, dynamic> json) {
    return StateTimeSeriesModel(
        stateCode: (json['state_code'] as String).toMapCode(),
        timeSeries: (json["time_series"] ?? [])
            .map((series) => TimeSeriesModel.fromJson(series))
            .toList()
            .cast<TimeSeriesModel>(),
        districts: (json["districts"] ?? [])
            .map((district) => DistrictTimeSeriesModel.fromJson(district))
            .toList()
            .cast<DistrictTimeSeriesModel>());
  }

  Map<String, dynamic> toJson() {
    return {
      'state_code': stateCode.key,
      'time_series': timeSeries
          .map((series) => TimeSeriesModel.fromEntity(series).toJson())
          .toList(),
      'districts': districts
          .map((district) =>
              DistrictTimeSeriesModel.fromEntity(district).toJson())
          .toList()
    };
  }
}

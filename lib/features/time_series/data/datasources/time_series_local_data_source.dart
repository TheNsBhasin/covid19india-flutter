import 'dart:convert';

import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/time_series/data/models/state_time_series_model.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TimeSeriesLocalDataSource {
  Future<List<StateTimeSeries>> getLastTimeSeries();

  Future<DateTime> getCachedTimeStamp({stateCode: 'TT'});

  Future<void> cacheTimeSeries(List<StateTimeSeries> timeSeries);

  Future<void> cacheStateTimeSeries(
      StateTimeSeries timeSeries, MapCodes stateCode);

  Future<StateTimeSeries> getStateTimeSeries(MapCodes stateCode);
}

const CACHED_TIME_SERIES = 'CACHED_TIME_SERIES';

class TimeSeriesLocalDataSourceImpl implements TimeSeriesLocalDataSource {
  final SharedPreferences sharedPreferences;

  TimeSeriesLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheTimeSeries(List<StateTimeSeries> timeSeries) {
    Map<String, dynamic> jsonMap = {};

    try {
      jsonMap = ResponseParser.timeSeriesToJson(timeSeries);
    } catch (e) {
      debugPrint("cacheTimeSeries: $e");
      return null;
    }

    jsonMap['time_stamp'] = new DateTime.now().toString();

    return sharedPreferences.setString(
      CACHED_TIME_SERIES,
      json.encode(jsonMap),
    );
  }

  @override
  Future<List<StateTimeSeries>> getLastTimeSeries() async {
    final jsonString = sharedPreferences.getString(CACHED_TIME_SERIES);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return jsonMap["results"]
            .map((result) => StateTimeSeriesModel.fromJson(result).toEntity())
            .toList()
            .cast<StateTimeSeries>();
      } catch (e) {
        debugPrint("getLastTimeSeries: ${e.toString()}");
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> getCachedTimeStamp({stateCode: 'TT'}) {
    final jsonString = stateCode == 'TT'
        ? sharedPreferences.getString(CACHED_TIME_SERIES)
        : sharedPreferences.getString("${CACHED_TIME_SERIES}_$stateCode");
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return Future.value(DateTime.parse(jsonMap['time_stamp']));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheStateTimeSeries(
      StateTimeSeries timeSeries, MapCodes stateCode) {
    Map<String, dynamic> jsonMap = {};

    try {
      jsonMap = ResponseParser.stateTimeSeriesToJson(timeSeries);
    } catch (e) {
      debugPrint("cacheStateTimeSeries: $e");
      return null;
    }

    jsonMap['time_stamp'] = new DateTime.now().toString();

    return sharedPreferences.setString(
      CACHED_TIME_SERIES + "_${stateCode.key}",
      json.encode(jsonMap),
    );
  }

  @override
  Future<StateTimeSeries> getStateTimeSeries(MapCodes stateCode) async {
    final jsonString =
        sharedPreferences.getString("${CACHED_TIME_SERIES}_${stateCode.key}");
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return Future.value(
            StateTimeSeriesModel.fromJson(jsonMap["result"]).toEntity());
      } catch (e) {
        debugPrint("getStateTimeSeries: ${e.toString()}");
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }
}

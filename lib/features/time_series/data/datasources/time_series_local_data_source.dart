import 'dart:convert';

import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/time_series/data/models/state_wise_time_series_model.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TimeSeriesLocalDataSource {
  Future<List<StateWiseTimeSeries>> getLastTimeSeries();

  Future<DateTime> getCachedTimeStamp();

  Future<void> cacheTimeSeries(List<StateWiseTimeSeries> timeSeries);
}

const CACHED_TIME_SERIES = 'CACHED_TIME_SERIES';

class TimeSeriesLocalDataSourceImpl implements TimeSeriesLocalDataSource {
  final SharedPreferences sharedPreferences;

  TimeSeriesLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheTimeSeries(List<StateWiseTimeSeries> timeSeries) {
    Map<String, dynamic> jsonMap = ResponseParser.timeSeriesToJson(
        timeSeries.cast<StateWiseTimeSeriesModel>());

    jsonMap['time_stamp'] = new DateTime.now().toString();

    return sharedPreferences.setString(
      CACHED_TIME_SERIES,
      json.encode(jsonMap),
    );
  }

  @override
  Future<List<StateWiseTimeSeries>> getLastTimeSeries() {
    final jsonString = sharedPreferences.getString(CACHED_TIME_SERIES);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return Future.value(jsonMap["results"]
          .map((result) => StateWiseTimeSeriesModel.fromJson(result))
          .toList()
          .cast<StateWiseTimeSeriesModel>());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> getCachedTimeStamp() {
    final jsonString = sharedPreferences.getString(CACHED_TIME_SERIES);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return Future.value(DateTime.parse(jsonMap['time_stamp']));
    } else {
      throw CacheException();
    }
  }
}

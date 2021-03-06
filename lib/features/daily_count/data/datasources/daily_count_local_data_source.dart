import 'dart:convert';

import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/daily_count/data/models/state_daily_count_model.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DailyCountLocalDataSource {
  Future<List<StateDailyCount>> getLastDailyCount({DateTime date});

  Future<List<StateDailyCount>> getCachedDailyCount({DateTime date});

  Future<DateTime> getCachedTimeStamp({DateTime date});

  Future<void> cacheDailyCount(List<StateDailyCount> dailyCounts,
      {DateTime date});
}

const CACHED_DAILY_COUNTS = 'CACHED_DAILY_COUNTS';

class DailyCountLocalDataSourceImpl implements DailyCountLocalDataSource {
  final SharedPreferences sharedPreferences;

  DailyCountLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheDailyCount(List<StateDailyCount> dailyCounts,
      {DateTime date}) {
    Map<String, dynamic> jsonMap = {};

    try {
      jsonMap = ResponseParser.dailyCountsToJson(dailyCounts);
    } catch (e) {
      debugPrint("cacheDailyCount: ${e.toString()}");
      return null;
    }

    jsonMap['time_stamp'] = new DateTime.now().toString();

    return sharedPreferences.setString(
      CACHED_DAILY_COUNTS +
          (date != null && !date.isToday()
              ? "_${DateFormat("yyyy-MM-dd").format(date)}"
              : ""),
      json.encode(jsonMap),
    );
  }

  @override
  Future<List<StateDailyCount>> getLastDailyCount({DateTime date}) {
    final jsonString = sharedPreferences.getString(CACHED_DAILY_COUNTS +
        (date != null && !date.isToday()
            ? "_${DateFormat("yyyy-MM-dd").format(date)}"
            : ""));
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      try {
        return Future.value(jsonMap["results"]
            .map((result) => StateDailyCountModel.fromJson(result).toEntity())
            .toList()
            .cast<StateDailyCount>());
      } catch (e) {
        debugPrint("getLastDailyCount: ${e.toString()}");
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> getCachedTimeStamp({DateTime date}) {
    final jsonString = sharedPreferences.getString(CACHED_DAILY_COUNTS +
        (date != null && !date.isToday()
            ? "_${DateFormat("yyyy-MM-dd").format(date)}"
            : ""));
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return Future.value(DateTime.parse(jsonMap['time_stamp']));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<StateDailyCount>> getCachedDailyCount({DateTime date}) {
    final jsonString = sharedPreferences.getString(CACHED_DAILY_COUNTS +
        (date != null && !date.isToday()
            ? "_${DateFormat("yyyy-MM-dd").format(date)}"
            : ""));
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      try {
        return Future.value(jsonMap["results"]
            .map((result) => StateDailyCountModel.fromJson(result).toEntity())
            .toList());
      } catch (e) {
        debugPrint("getCachedDailyCount: ${e.toString()}");
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }
}

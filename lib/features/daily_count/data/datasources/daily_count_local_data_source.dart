import 'dart:convert';

import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/daily_count/data/models/state_wise_daily_count_model.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DailyCountLocalDataSource {
  Future<List<StateWiseDailyCount>> getLastDailyCount();

  Future<DateTime> getCachedTimeStamp();

  Future<void> cacheDailyCount(List<StateWiseDailyCount> dailyCounts);
}

const CACHED_DAILY_COUNTS = 'CACHED_DAILY_COUNTS';

class DailyCountLocalDataSourceImpl implements DailyCountLocalDataSource {
  final SharedPreferences sharedPreferences;

  DailyCountLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheDailyCount(List<StateWiseDailyCount> dailyCounts) {
    Map<String, dynamic> jsonMap = ResponseParser.dailyCountsToJson(
        dailyCounts.cast<StateWiseDailyCountModel>());

    jsonMap['time_stamp'] = new DateTime.now().toString();

    return sharedPreferences.setString(
      CACHED_DAILY_COUNTS,
      json.encode(jsonMap),
    );
  }

  @override
  Future<List<StateWiseDailyCount>> getLastDailyCount() {
    final jsonString = sharedPreferences.getString(CACHED_DAILY_COUNTS);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return Future.value(jsonMap["results"]
          .map((result) => StateWiseDailyCountModel.fromJson(result))
          .toList()
          .cast<StateWiseDailyCountModel>());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> getCachedTimeStamp() {
    final jsonString = sharedPreferences.getString(CACHED_DAILY_COUNTS);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return Future.value(DateTime.parse(jsonMap['time_stamp']));
    } else {
      throw CacheException();
    }
  }
}

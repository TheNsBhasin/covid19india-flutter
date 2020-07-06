import 'dart:convert';

import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/update_log/data/models/update_log_model.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UpdateLogLocalDataSource {
  Future<List<UpdateLog>> getLastUpdateLogs();

  Future<DateTime> getLastViewedTimestamp();

  Future<void> storeLastViewedTimestamp(DateTime timestamp);

  Future<DateTime> getCachedTimeStamp();

  Future<void> cacheUpdateLogs(List<UpdateLog> updateLogs);
}

const CACHED_UPDATE_LOG = 'CACHED_UPDATE_LOG';
const LAST_VIEWED_UPDATE_LOG_TIMESTAMP = 'LAST_VIEWED_UPDATE_LOG_TIMESTAMP';

class UpdateLogLocalDataSourceImpl implements UpdateLogLocalDataSource {
  final SharedPreferences sharedPreferences;

  UpdateLogLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheUpdateLogs(List<UpdateLog> updateLogs) {
    Map<String, dynamic> jsonMap =
        ResponseParser.updateLogsToJson(updateLogs.cast<UpdateLogModel>());

    jsonMap['time_stamp'] = new DateTime.now().toString();

    return sharedPreferences.setString(
      CACHED_UPDATE_LOG,
      json.encode(jsonMap),
    );
  }

  @override
  Future<List<UpdateLog>> getLastUpdateLogs() {
    final jsonString = sharedPreferences.getString(CACHED_UPDATE_LOG);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return Future.value(jsonMap["results"]
          .map((result) => UpdateLogModel.fromJson(result))
          .toList()
          .cast<UpdateLogModel>());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> getCachedTimeStamp() {
    final jsonString = sharedPreferences.getString(CACHED_UPDATE_LOG);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return Future.value(DateTime.parse(jsonMap['time_stamp']));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> getLastViewedTimestamp() {
    final lastViewedTimestamp =
        sharedPreferences.getString(LAST_VIEWED_UPDATE_LOG_TIMESTAMP);
    if (lastViewedTimestamp != null) {
      return Future.value(DateTime.parse(lastViewedTimestamp));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> storeLastViewedTimestamp(DateTime timestamp) {
    return sharedPreferences.setString(
      LAST_VIEWED_UPDATE_LOG_TIMESTAMP,
      timestamp.toString(),
    );
  }
}

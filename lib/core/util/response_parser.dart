import 'package:covid19india/features/daily_count/data/models/state_daily_count_model.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:covid19india/features/time_series/data/models/state_time_series_model.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:covid19india/features/update_log/data/models/update_log_model.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:flutter/foundation.dart';

class ResponseParser {
  static Map<String, dynamic> jsonToDailyCounts(Map<String, dynamic> json) {
    return {'results': parseJsonToDailyCount(json)};
  }

  static Map<String, dynamic> dailyCountsToJson(
      List<StateDailyCount> dailyCounts) {
    return {
      'results': dailyCounts
          .map((e) => StateDailyCountModel.fromEntity(e).toJson())
          .toList()
    };
  }

  static Map<String, dynamic> jsonToTimeSeries(Map<String, dynamic> json) {
    return {'results': parseJsonToTimeSeries(json)};
  }

  static Map<String, dynamic> timeSeriesToJson(
      List<StateTimeSeries> timeSeries) {
    return {
      'results': timeSeries
          .map((stateData) =>
              StateTimeSeriesModel.fromEntity(stateData).toJson())
          .toList()
    };
  }

  static Map<String, dynamic> jsonToStateTimeSeries(Map<String, dynamic> json) {
    return {'result': parseJsonToTimeSeries(json).first};
  }

  static Map<String, dynamic> stateTimeSeriesToJson(
      StateTimeSeries timeSeries) {
    return {'result': StateTimeSeriesModel.fromEntity(timeSeries).toJson()};
  }

  static Map<String, dynamic> jsonToUpdateLogs(List<dynamic> json) {
    return {'results': parseJsonToUpdateLogs(json)};
  }

  static Map<String, dynamic> updateLogsToJson(List<UpdateLog> updateLogs) {
    return {
      'results': updateLogs
          .map((updateLog) => UpdateLogModel.fromEntity(updateLog).toJson())
          .toList()
    };
  }
}

List<Map<String, dynamic>> parseJsonToDailyCount(Map<String, dynamic> json) {
  try {
    return json.entries
        .map((e) => {
              'state_code': e.key,
              'total': {
                'confirmed': (e.value['total'] ?? {})['confirmed'] ?? 0,
                'recovered': (e.value['total'] ?? {})['recovered'] ?? 0,
                'deceased': (e.value['total'] ?? {})['deceased'] ?? 0,
                'tested': (e.value['total'] ?? {})['tested'] ?? 0,
                'migrated': (e.value['total'] ?? {})['migrated'] ?? 0,
              },
              'delta': {
                'confirmed': (e.value['delta'] ?? {})['confirmed'] ?? 0,
                'recovered': (e.value['delta'] ?? {})['recovered'] ?? 0,
                'deceased': (e.value['delta'] ?? {})['deceased'] ?? 0,
                'tested': (e.value['delta'] ?? {})['tested'] ?? 0,
                'migrated': (e.value['total'] ?? {})['migrated'] ?? 0,
              },
              'metadata': {
                'last_updated': (e.value['meta'] ?? {})['last_updated'] ?? "",
                'population': (e.value['meta'] ?? {})["population"] ?? null,
                'notes': (e.value['meta'] ?? {})['notes'] ?? "",
                'tested':
                    (e.value['meta'] ?? {})['tested'] ?? Map<String, dynamic>()
              },
              'districts': (e.value['districts'] ?? {})
                  .entries
                  .map((e) => {
                        'name': e.key,
                        'total': {
                          'confirmed':
                              (e.value['total'] ?? {})['confirmed'] ?? 0,
                          'recovered':
                              (e.value['total'] ?? {})['recovered'] ?? 0,
                          'deceased': (e.value['total'] ?? {})['deceased'] ?? 0,
                          'tested': (e.value['total'] ?? {})['tested'] ?? 0,
                          'migrated': (e.value['total'] ?? {})['migrated'] ?? 0,
                        },
                        'delta': {
                          'confirmed':
                              (e.value['delta'] ?? {})['confirmed'] ?? 0,
                          'recovered':
                              (e.value['delta'] ?? {})['recovered'] ?? 0,
                          'deceased': (e.value['delta'] ?? {})['deceased'] ?? 0,
                          'tested': (e.value['delta'] ?? {})['tested'] ?? 0,
                          'migrated': (e.value['total'] ?? {})['migrated'] ?? 0,
                        },
                        'metadata': {
                          'last_updated':
                              (e.value['meta'] ?? {})['last_updated'] ?? "",
                          'population':
                              (e.value['meta'] ?? {})["population"] ?? null,
                          'notes': (e.value['meta'] ?? {})['notes'] ?? "",
                          'tested': (e.value['meta'] ?? {})['tested'] ??
                              Map<String, dynamic>()
                        },
                      })
                  .toList()
            })
        .toList();
  } catch (e) {
    debugPrint("parseJsonToDailyCount: ${e.toString()}");
    return [];
  }
}

List<Map<String, dynamic>> parseJsonToUpdateLogs(List<dynamic> json) {
  try {
    return json
        .map((updateLog) => {
              "update": updateLog["update"],
              "timestamp": updateLog["timestamp"]
            })
        .toList();
  } catch (e) {
    debugPrint("parseJsonToUpdateLogs: ${e.toString()}");
    return [];
  }
}

List<Map<String, dynamic>> parseJsonToTimeSeries(Map<String, dynamic> json) {
  try {
    return json.entries
        .map((stateData) => {
              'state_code': stateData.key,
              'time_series': (stateData.value['dates'] ?? {})
                  .entries
                  .map((timeSeries) => {
                        'date': timeSeries.key,
                        'total': {
                          'confirmed':
                              (timeSeries.value['total'] ?? {})['confirmed'] ??
                                  0,
                          'recovered':
                              (timeSeries.value['total'] ?? {})['recovered'] ??
                                  0,
                          'deceased':
                              (timeSeries.value['total'] ?? {})['deceased'] ??
                                  0,
                          'tested':
                              (timeSeries.value['total'] ?? {})['tested'] ?? 0,
                          'migrated':
                              (timeSeries.value['total'] ?? {})['migrated'] ??
                                  0,
                        },
                        'delta': {
                          'confirmed':
                              (timeSeries.value['delta'] ?? {})['confirmed'] ??
                                  0,
                          'recovered':
                              (timeSeries.value['delta'] ?? {})['recovered'] ??
                                  0,
                          'deceased':
                              (timeSeries.value['delta'] ?? {})['deceased'] ??
                                  0,
                          'tested':
                              (timeSeries.value['delta'] ?? {})['tested'] ?? 0,
                          'migrated':
                              (timeSeries.value['delta'] ?? {})['migrated'] ??
                                  0,
                        }
                      })
                  .toList(),
              'districts': (stateData.value['districts'] ?? {})
                  .entries
                  .map((districtData) => {
                        'name': districtData.key,
                        'time_series': (districtData.value['dates'] ?? {})
                            .entries
                            .map((timeSeries) => {
                                  'date': timeSeries.key,
                                  'total': {
                                    'confirmed': (timeSeries.value['total'] ??
                                            {})['confirmed'] ??
                                        0,
                                    'recovered': (timeSeries.value['total'] ??
                                            {})['recovered'] ??
                                        0,
                                    'deceased': (timeSeries.value['total'] ??
                                            {})['deceased'] ??
                                        0,
                                    'tested': (timeSeries.value['total'] ??
                                            {})['tested'] ??
                                        0,
                                    'migrated': (timeSeries.value['total'] ??
                                            {})['migrated'] ??
                                        0,
                                  },
                                  'delta': {
                                    'confirmed': (timeSeries.value['delta'] ??
                                            {})['confirmed'] ??
                                        0,
                                    'recovered': (timeSeries.value['delta'] ??
                                            {})['recovered'] ??
                                        0,
                                    'deceased': (timeSeries.value['delta'] ??
                                            {})['deceased'] ??
                                        0,
                                    'tested': (timeSeries.value['delta'] ??
                                            {})['tested'] ??
                                        0,
                                    'migrated': (timeSeries.value['delta'] ??
                                            {})['migrated'] ??
                                        0,
                                  }
                                })
                            .toList()
                      })
                  .toList()
            })
        .toList();
  } catch (e) {
    debugPrint("parseJsonToTimeSeries: ${e.toString()}");
    return [];
  }
}

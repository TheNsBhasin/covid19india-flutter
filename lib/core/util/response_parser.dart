import 'package:covid19india/features/daily_count/data/models/state_wise_daily_count_model.dart';
import 'package:covid19india/features/time_series/data/models/state_wise_time_series_model.dart';

class ResponseParser {
  static Map<String, dynamic> jsonToDailyCounts(Map<String, dynamic> json) {
    return {'results': parseJsonToDailyCount(json)};
  }

  static Map<String, dynamic> dailyCountsToJson(
      List<StateWiseDailyCountModel> dailyCounts) {
    return {'results': dailyCounts.map((e) => e.toJson()).toList()};
  }

  static Map<String, dynamic> jsonToTimeSeries(Map<String, dynamic> json) {
    return {'results': parseJsonToTimeSeries(json)};
  }

  static Map<String, dynamic> timeSeriesToJson(
      List<StateWiseTimeSeriesModel> timeSeries) {
    return {
      'results': timeSeries.map((stateData) => stateData.toJson()).toList()
    };
  }
}

List<Map<String, dynamic>> parseJsonToDailyCount(Map<String, dynamic> json) {
  return json.entries
      .map((e) => {
            'name': e.key,
            'total': {
              'confirmed': (e.value['total'] ?? {})['confirmed'] ?? 0,
              'recovered': (e.value['total'] ?? {})['recovered'] ?? 0,
              'deceased': (e.value['total'] ?? {})['deceased'] ?? 0,
              'tested': (e.value['total'] ?? {})['tested'] ?? 0
            },
            'delta': {
              'confirmed': (e.value['delta'] ?? {})['confirmed'] ?? 0,
              'recovered': (e.value['delta'] ?? {})['recovered'] ?? 0,
              'deceased': (e.value['delta'] ?? {})['deceased'] ?? 0,
              'tested': (e.value['delta'] ?? {})['tested'] ?? 0
            },
            'metadata': {
              'last_updated': (e.value['meta'] ?? {})['last_updated'] ?? "",
              'notes': (e.value['meta'] ?? {})['notes'] ?? "",
              'tested': (e.value['meta'] ?? {})['tested'] ?? Map<String, dynamic>()
            },
            'districts': (e.value['districts'] ?? {})
                .entries
                .map((e) => {
                      'name': e.key,
                      'total': {
                        'confirmed': (e.value['total'] ?? {})['confirmed'] ?? 0,
                        'recovered': (e.value['total'] ?? {})['recovered'] ?? 0,
                        'deceased': (e.value['total'] ?? {})['deceased'] ?? 0,
                        'tested': (e.value['total'] ?? {})['tested'] ?? 0
                      },
                      'delta': {
                        'confirmed': (e.value['delta'] ?? {})['confirmed'] ?? 0,
                        'recovered': (e.value['delta'] ?? {})['recovered'] ?? 0,
                        'deceased': (e.value['delta'] ?? {})['deceased'] ?? 0,
                        'tested': (e.value['delta'] ?? {})['tested'] ?? 0
                      },
                    })
                .toList()
          })
      .toList();
}

List<Map<String, dynamic>> parseJsonToTimeSeries(Map<String, dynamic> json) {
  return json.entries
      .map((stateData) => {
            'name': stateData.key,
            'time_series': stateData.value.entries
                .map((timeSeries) => {
                      'date': timeSeries.key,
                      'total': {
                        'confirmed':
                            (timeSeries.value['total'] ?? {})['confirmed'] ?? 0,
                        'recovered':
                            (timeSeries.value['total'] ?? {})['recovered'] ?? 0,
                        'deceased':
                            (timeSeries.value['total'] ?? {})['deceased'] ?? 0,
                        'tested':
                            (timeSeries.value['total'] ?? {})['tested'] ?? 0
                      },
                      'delta': {
                        'confirmed':
                            (timeSeries.value['delta'] ?? {})['confirmed'] ?? 0,
                        'recovered':
                            (timeSeries.value['delta'] ?? {})['recovered'] ?? 0,
                        'deceased':
                            (timeSeries.value['delta'] ?? {})['deceased'] ?? 0,
                        'tested':
                            (timeSeries.value['delta'] ?? {})['tested'] ?? 0
                      }
                    })
                .toList()
          })
      .toList();
}

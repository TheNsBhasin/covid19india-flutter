import 'dart:convert';

import 'package:covid19india/core/constants/endpoints.dart';
import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/daily_count/data/models/state_daily_count_model.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class DailyCountRemoteDataSource {
  Future<List<StateDailyCount>> getDailyCount(DateTime date);
}

class DailyCountRemoteDataSourceImpl implements DailyCountRemoteDataSource {
  final http.Client client;

  DailyCountRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<StateDailyCount>> getDailyCount(DateTime date) {
    String url = Endpoints.DAILY_COUNTS;

    if (date != null && !date.isToday()) {
      url = Endpoints.dailyCount(date: date);
    }

    return _getDailyCountFromUrl(
        date.isToday() ? url : Endpoints.dailyCount(date: date));
  }

  Future<List<StateDailyCount>> _getDailyCountFromUrl(String url) async {
    final response = await client.get(url, headers: {
      'Content-Type': 'application/json',
    }).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = ResponseParser.jsonToDailyCounts(
          json.decode(response.body.toString()));

      try {
        return jsonMap["results"]
            .map((result) => StateDailyCountModel.fromJson(result).toEntity())
            .toList()
            .cast<StateDailyCount>();
      } catch (e) {
        debugPrint("_getDailyCountFromUrl: ${e.toString()}");
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}

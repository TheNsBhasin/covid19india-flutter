import 'dart:convert';

import 'package:covid19india/core/constants/endpoints.dart';
import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/time_series/data/models/state_wise_time_series_model.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class TimeSeriesRemoteDataSource {
  Future<List<StateWiseTimeSeries>> getTimeSeries();

  Future<StateWiseTimeSeries> getStateTimeSeries(String stateCode);
}

class TimeSeriesRemoteDataSourceImpl implements TimeSeriesRemoteDataSource {
  final http.Client client;

  TimeSeriesRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<StateWiseTimeSeries>> getTimeSeries() =>
      _getTimeSeriesFromUrl(Endpoints.TIME_SERIES);

  Future<List<StateWiseTimeSeries>> _getTimeSeriesFromUrl(String url) async {
    final response = await client.get(url, headers: {
      'Content-Type': 'application/json',
    }).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonMap = ResponseParser.jsonToTimeSeries(
            json.decode(response.body.toString()));
        return jsonMap["results"]
            .map((result) => StateWiseTimeSeriesModel.fromJson(result))
            .toList()
            .cast<StateWiseTimeSeries>();
      } catch (e) {
        debugPrint("_getTimeSeriesFromUrl: ${e.toString()}");
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<StateWiseTimeSeries> getStateTimeSeries(String stateCode) =>
      _getStateTimeSeriesFromUrl(Endpoints.timeSeries(stateCode: stateCode));

  Future<StateWiseTimeSeries> _getStateTimeSeriesFromUrl(String url) async {
    final response = await client.get(url, headers: {
      'Content-Type': 'application/json',
    }).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonMap = ResponseParser.jsonToStateTimeSeries(
            json.decode(response.body.toString()));
        return StateWiseTimeSeriesModel.fromJson(jsonMap["result"]);
      } catch (e) {
        debugPrint("_getTimeSeriesFromUrl: ${e.toString()}");
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}

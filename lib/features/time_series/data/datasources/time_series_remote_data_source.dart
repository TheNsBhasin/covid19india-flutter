import 'dart:convert';

import 'package:covid19india/core/constants/endpoints.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/time_series/data/models/state_time_series_model.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class TimeSeriesRemoteDataSource {
  Future<List<StateTimeSeries>> getTimeSeries();

  Future<StateTimeSeries> getStateTimeSeries(MapCodes stateCode);
}

class TimeSeriesRemoteDataSourceImpl implements TimeSeriesRemoteDataSource {
  final http.Client client;

  TimeSeriesRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<StateTimeSeries>> getTimeSeries() =>
      _getTimeSeriesFromUrl(Endpoints.TIME_SERIES);

  Future<List<StateTimeSeries>> _getTimeSeriesFromUrl(String url) async {
    final response = await client.get(url, headers: {
      'Content-Type': 'application/json',
    }).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonMap = ResponseParser.jsonToTimeSeries(
            json.decode(response.body.toString()));
        return jsonMap["results"]
            .map((result) => StateTimeSeriesModel.fromJson(result).toEntity())
            .toList()
            .cast<StateTimeSeries>();
      } catch (e) {
        debugPrint("_getTimeSeriesFromUrl: $e");
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<StateTimeSeries> getStateTimeSeries(MapCodes stateCode) =>
      _getStateTimeSeriesFromUrl(
          Endpoints.timeSeries(stateCode: stateCode.key));

  Future<StateTimeSeries> _getStateTimeSeriesFromUrl(String url) async {
    final response = await client.get(url, headers: {
      'Content-Type': 'application/json',
    }).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonMap = ResponseParser.jsonToStateTimeSeries(
            json.decode(response.body.toString()));
        return StateTimeSeriesModel.fromJson(jsonMap["result"]).toEntity();
      } catch (e) {
        debugPrint("_getTimeSeriesFromUrl: ${e.toString()}");
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}

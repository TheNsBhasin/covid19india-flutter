import 'dart:convert';

import 'package:covid19india/core/constants/endpoints.dart';
import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/update_log/data/models/update_log_model.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class UpdateLogRemoteDataSource {
  Future<List<UpdateLog>> getUpdateLogs();
}

class UpdateLogRemoteDataSourceImpl implements UpdateLogRemoteDataSource {
  final http.Client client;

  UpdateLogRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<UpdateLog>> getUpdateLogs() =>
      _getUpdateLogsFromUrl(Endpoints.UPDATE_LOGS);

  Future<List<UpdateLog>> _getUpdateLogsFromUrl(String url) async {
    final response = await client.get(url, headers: {
      'Content-Type': 'application/json',
    }).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = ResponseParser.jsonToUpdateLogs(
          json.decode(response.body.toString()));

      return jsonMap["results"]
          .map((result) => UpdateLogModel.fromJson(result))
          .toList()
          .cast<UpdateLogModel>();
    } else {
      print('ServerException');
      throw ServerException();
    }
  }
}

import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/usecases/usecase.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:covid19india/features/update_log/domain/repositories/update_log_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetUpdateLogs implements UseCase<List<UpdateLog>, GetUpdateLogsParams> {
  final UpdateLogRepository repository;

  GetUpdateLogs(this.repository);

  @override
  Future<Either<Failure, List<UpdateLog>>> call(
      GetUpdateLogsParams params) async {
    return await repository.getUpdateLogs(forced: params.forced);
  }
}

class GetUpdateLogsParams extends Equatable {
  final bool forced;

  GetUpdateLogsParams({@required this.forced});

  @override
  List<Object> get props => [forced];
}

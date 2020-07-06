import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/usecases/usecase.dart';
import 'package:covid19india/features/update_log/domain/repositories/update_log_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StoreLastViewedTimestamp implements UseCase<void, StoreLastViewedTimestampParams> {
  final UpdateLogRepository repository;

  StoreLastViewedTimestamp(this.repository);

  @override
  Future<Either<Failure, void>> call(StoreLastViewedTimestampParams params) async {
    return await repository.storeLastViewedTimestamp(
        timestamp: params.timestamp);
  }
}

class StoreLastViewedTimestampParams extends Equatable {
  final DateTime timestamp;

  StoreLastViewedTimestampParams({@required this.timestamp});

  @override
  List<Object> get props => [timestamp];
}

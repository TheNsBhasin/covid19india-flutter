import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/usecases/usecase.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:covid19india/features/time_series/domain/repositories/time_series_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetStateTimeSeries
    implements UseCase<StateTimeSeries, GetStateTimeSeriesParams> {
  final TimeSeriesRepository repository;

  GetStateTimeSeries(this.repository);

  @override
  Future<Either<Failure, StateTimeSeries>> call(
      GetStateTimeSeriesParams params) async {
    return await repository.getStateTimeSeries(
        forced: params.forced,
        cache: params.cache,
        stateCode: params.stateCode);
  }
}

class GetStateTimeSeriesParams extends Equatable {
  final bool forced;
  final bool cache;
  final MapCodes stateCode;

  GetStateTimeSeriesParams(
      {@required this.forced, @required this.cache, @required this.stateCode});

  @override
  List<Object> get props => [forced, cache, stateCode];

  @override
  bool get stringify => true;
}

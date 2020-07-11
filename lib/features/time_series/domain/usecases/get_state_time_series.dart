import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/usecases/usecase.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/domain/repositories/time_series_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetStateTimeSeries implements UseCase<StateWiseTimeSeries, GetStateTimeSeriesParams> {
  final TimeSeriesRepository repository;

  GetStateTimeSeries(this.repository);

  @override
  Future<Either<Failure, StateWiseTimeSeries>> call(GetStateTimeSeriesParams params) async {
    return await repository.getStateTimeSeries(
        forced: params.forced,
        cache: params.cache,
        stateCode: params.stateCode);
  }
}

class GetStateTimeSeriesParams extends Equatable {
  final bool forced;
  final bool cache;
  final String stateCode;

  GetStateTimeSeriesParams({@required this.forced, this.cache, this.stateCode});

  @override
  List<Object> get props => [forced, cache, stateCode];

  @override
  bool get stringify => true;
}

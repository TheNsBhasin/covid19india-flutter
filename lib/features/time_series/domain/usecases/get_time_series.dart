import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/usecases/usecase.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/domain/repositories/time_series_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetTimeSeries implements UseCase<List<StateWiseTimeSeries>, Params> {
  final TimeSeriesRepository repository;

  GetTimeSeries(this.repository);

  @override
  Future<Either<Failure, List<StateWiseTimeSeries>>> call(
      Params params) async {
    return await repository.getTimeSeries(forced: params.forced);
  }
}

class Params extends Equatable {
  final bool forced;

  Params({@required this.forced});

  @override
  List<Object> get props => [forced];
}

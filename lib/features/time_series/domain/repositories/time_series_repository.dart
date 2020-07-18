import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/features/time_series/domain/entities/state_time_series.dart';
import 'package:dartz/dartz.dart';

abstract class TimeSeriesRepository {
  Future<Either<Failure, List<StateTimeSeries>>> getTimeSeries(
      {bool forced, bool cache});

  Future<Either<Failure, StateTimeSeries>> getStateTimeSeries(
      {bool forced, bool cache, MapCodes stateCode});
}

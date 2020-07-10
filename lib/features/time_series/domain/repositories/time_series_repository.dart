import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:dartz/dartz.dart';

abstract class TimeSeriesRepository {
  Future<Either<Failure, List<StateWiseTimeSeries>>> getTimeSeries(
      {bool forced});
}

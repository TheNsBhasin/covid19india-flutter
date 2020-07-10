import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/network/network_info.dart';
import 'package:covid19india/features/time_series/data/datasources/time_series_local_data_source.dart';
import 'package:covid19india/features/time_series/data/datasources/time_series_remote_data_source.dart';
import 'package:covid19india/features/time_series/domain/entities/state_wise_time_series.dart';
import 'package:covid19india/features/time_series/domain/repositories/time_series_repository.dart';
import 'package:dartz/dartz.dart';

class TimeSeriesRepositoryImpl implements TimeSeriesRepository {
  final TimeSeriesRemoteDataSource remoteDataSource;
  final TimeSeriesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TimeSeriesRepositoryImpl(
      {this.remoteDataSource, this.localDataSource, this.networkInfo});

  @override
  Future<Either<Failure, List<StateWiseTimeSeries>>> getTimeSeries(
      {bool forced}) async {
    return await _getTimeSeries(forced: forced);
  }

  Future<Either<Failure, List<StateWiseTimeSeries>>> _getTimeSeries(
      {bool forced}) async {
    if (await networkInfo.isConnected) {
      try {
        if (!forced) {
          try {
            final DateTime lastCached =
                await localDataSource.getCachedTimeStamp();
            if (new DateTime.now().difference(lastCached).inMinutes <=
                Constants.CACHE_TIMEOUT_IN_MINUTES) {
              final localTimeSeries = await localDataSource.getLastTimeSeries();
              return Right(localTimeSeries);
            }
          } on CacheException {
            print('CacheException');
          }
        }
        final remoteTimeSeries = await remoteDataSource.getTimeSeries();
        localDataSource.cacheTimeSeries(remoteTimeSeries);
        return Right(remoteTimeSeries);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTimeSeries = await localDataSource.getLastTimeSeries();
        return Right(localTimeSeries);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

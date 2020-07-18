import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/network/network_info.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/features/daily_count/data/datasources/daily_count_local_data_source.dart';
import 'package:covid19india/features/daily_count/data/datasources/daily_count_remote_data_source.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/repositories/daily_count_repository.dart';
import 'package:dartz/dartz.dart';

class DailyCountRepositoryImpl implements DailyCountRepository {
  final DailyCountRemoteDataSource remoteDataSource;
  final DailyCountLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DailyCountRepositoryImpl({
    this.remoteDataSource,
    this.localDataSource,
    this.networkInfo,
  });

  @override
  Future<Either<Failure, List<StateDailyCount>>> getDailyCount({
    bool forced,
    bool cache,
    DateTime date,
  }) async {
    return await _getDailyCount(forced: forced, cache: cache, date: date);
  }

  Future<Either<Failure, List<StateDailyCount>>> _getDailyCount({
    bool forced,
    bool cache,
    DateTime date,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        if (!forced) {
          try {
            final DateTime lastCached =
                await localDataSource.getCachedTimeStamp(date: date);
            if (DateTime.now().difference(lastCached).inMinutes <=
                    CACHE_TIMEOUT_IN_MINUTES ||
                !date.isToday()) {
              final localDailyCounts =
                  await localDataSource.getLastDailyCount(date: date);
              return Right(localDailyCounts);
            }
          } on CacheException {}
        }

        final remoteDailyCounts = await remoteDataSource.getDailyCount(date);

        if (cache) {
          try {
            localDataSource.cacheDailyCount(remoteDailyCounts, date: date);
          } catch (e) {
            print('DailyCountRepositoryImpl: _getDailyCount: $e');
          }
        }

        return Right(remoteDailyCounts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localDailyCounts =
            await localDataSource.getLastDailyCount(date: date);
        return Right(localDailyCounts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/network/network_info.dart';
import 'package:covid19india/features/update_log/data/datasources/update_log_local_data_source.dart';
import 'package:covid19india/features/update_log/data/datasources/update_log_remote_datasource.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:covid19india/features/update_log/domain/repositories/update_log_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateLogRepositoryImpl implements UpdateLogRepository {
  final UpdateLogRemoteDataSource remoteDataSource;
  final UpdateLogLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UpdateLogRepositoryImpl(
      {this.remoteDataSource, this.localDataSource, this.networkInfo});

  @override
  Future<Either<Failure, List<UpdateLog>>> getUpdateLogs(
      {forced: false}) async {
    return await _getUpdateLogs(forced: forced);
  }

  Future<Either<Failure, List<UpdateLog>>> _getUpdateLogs({forced}) async {
    if (await networkInfo.isConnected) {
      try {
        if (!forced) {
          try {
            final DateTime lastCached =
                await localDataSource.getCachedTimeStamp();
            if (new DateTime.now().difference(lastCached).inMinutes <=
                CACHE_TIMEOUT_IN_MINUTES) {
              final localUpdateLogs = await localDataSource.getLastUpdateLogs();
              return Right(localUpdateLogs);
            }
          } on CacheException {}
        }
        final remoteUpdateLogs = await remoteDataSource.getUpdateLogs();
        localDataSource.cacheUpdateLogs(remoteUpdateLogs);
        return Right(remoteUpdateLogs);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localUpdateLogs = await localDataSource.getLastUpdateLogs();
        return Right(localUpdateLogs);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, DateTime>> getLastViewedTimestamp() async {
    try {
      final lastViewedTimestamp =
          await localDataSource.getLastViewedTimestamp();
      return Right(lastViewedTimestamp);
    } on CacheException {
      return Right(new DateTime.fromMillisecondsSinceEpoch(0));
    }
  }

  @override
  Future<Either<Failure, void>> storeLastViewedTimestamp(
      {DateTime timestamp}) async {
    try {
      await localDataSource.storeLastViewedTimestamp(timestamp);
      return Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/features/update_log/domain/entities/update_log.dart';
import 'package:dartz/dartz.dart';

abstract class UpdateLogRepository {
  Future<Either<Failure, List<UpdateLog>>> getUpdateLogs({forced});
}

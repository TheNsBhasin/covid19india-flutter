import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/usecases/usecase.dart';
import 'package:covid19india/features/update_log/domain/repositories/update_log_repository.dart';
import 'package:dartz/dartz.dart';

class GetLastViewedTimestamp implements UseCase<DateTime, NoParams> {
  final UpdateLogRepository repository;

  GetLastViewedTimestamp(this.repository);

  @override
  Future<Either<Failure, DateTime>> call(NoParams params) async {
    return await repository.getLastViewedTimestamp();
  }
}

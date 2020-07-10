import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:dartz/dartz.dart';

abstract class DailyCountRepository {
  Future<Either<Failure, List<StateWiseDailyCount>>> getDailyCount(
      {bool forced, bool cache, DateTime date});
}

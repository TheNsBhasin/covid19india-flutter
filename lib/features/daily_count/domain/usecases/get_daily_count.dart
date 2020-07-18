import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/usecases/usecase.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/repositories/daily_count_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GetDailyCount
    implements UseCase<List<StateDailyCount>, DailyCountParams> {
  final DailyCountRepository repository;

  GetDailyCount(this.repository);

  @override
  Future<Either<Failure, List<StateDailyCount>>> call(
      DailyCountParams params) async {
    return await repository.getDailyCount(
        forced: params.forced, cache: params.cache, date: params.date);
  }
}

class DailyCountParams extends Equatable {
  final bool forced;
  final bool cache;
  final DateTime date;

  DailyCountParams({@required this.forced, @required this.cache, DateTime date})
      : this.date = date ?? DateTime.now();

  @override
  List<Object> get props => [forced, cache, date];
}

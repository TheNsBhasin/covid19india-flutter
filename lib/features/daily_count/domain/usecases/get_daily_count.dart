import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/usecases/usecase.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/repositories/daily_count_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetDailyCount implements UseCase<List<StateWiseDailyCount>, Params> {
  final DailyCountRepository repository;

  GetDailyCount(this.repository);

  @override
  Future<Either<Failure, List<StateWiseDailyCount>>> call(Params params) async {
    return await repository.getDailyCount(
        forced: params.forced, cache: params.cache, date: params.date);
  }
}

class Params extends Equatable {
  final bool forced;
  final bool cache;
  final DateTime date;

  Params({@required this.forced, this.cache, this.date});

  @override
  List<Object> get props => [forced, cache, date];
}

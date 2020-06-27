import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class DailyCountState extends Equatable {}

class Empty extends DailyCountState {
  @override
  List<Object> get props => [];
}

class Loading extends DailyCountState {
  @override
  List<Object> get props => [];
}

class Loaded extends DailyCountState {
  final List<StateWiseDailyCount> dailyCounts;

  Loaded({this.dailyCounts});

  @override
  List<Object> get props => [dailyCounts];
}

class Error extends DailyCountState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}

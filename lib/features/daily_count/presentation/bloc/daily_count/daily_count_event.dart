part of 'daily_count_bloc.dart';

abstract class DailyCountEvent extends Equatable {
  const DailyCountEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadDailyCount extends DailyCountEvent {
  final bool forced;
  final bool cache;
  final DateTime date;

  LoadDailyCount({this.forced: false, this.cache: true, this.date});

  @override
  List<Object> get props => [forced, cache, date];
}

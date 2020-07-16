part of 'page_bloc.dart';

abstract class StatePageEvent extends Equatable {
  const StatePageEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class DateChanged extends StatePageEvent {
  final DateTime date;

  DateChanged({@required this.date});

  @override
  List<Object> get props => [date];

  @override
  bool get stringify => true;
}

class StatisticChanged extends StatePageEvent {
  final STATISTIC statistic;

  StatisticChanged({@required this.statistic});

  @override
  List<Object> get props => [statistic];

  @override
  bool get stringify => true;
}

class RegionChanged extends StatePageEvent {
  final Region region;

  RegionChanged({@required this.region});

  @override
  List<Object> get props => [region];

  @override
  bool get stringify => true;
}

class RegionHighlightedChanged extends StatePageEvent {
  final Region regionHighlighted;

  RegionHighlightedChanged({@required this.regionHighlighted});

  @override
  List<Object> get props => [regionHighlighted];

  @override
  bool get stringify => true;
}

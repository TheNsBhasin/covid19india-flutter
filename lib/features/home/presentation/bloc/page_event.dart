part of 'page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class DateChanged extends HomePageEvent {
  final DateTime date;

  DateChanged({@required this.date});

  @override
  List<Object> get props => [date];

  @override
  bool get stringify => true;
}

class StatisticChanged extends HomePageEvent {
  final STATISTIC statistic;

  StatisticChanged({@required this.statistic});

  @override
  List<Object> get props => [statistic];

  @override
  bool get stringify => true;
}

class RegionHighlightedChanged extends HomePageEvent {
  final Region regionHighlighted;

  RegionHighlightedChanged({@required this.regionHighlighted});

  @override
  List<Object> get props => [regionHighlighted];

  @override
  bool get stringify => true;
}

part of 'statistic_bloc.dart';

abstract class StatisticEvent extends Equatable {
  const StatisticEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class StatisticChanged extends StatisticEvent {
  final Statistic statistic;

  const StatisticChanged({this.statistic});

  @override
  List<Object> get props => [statistic];
}

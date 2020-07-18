part of 'daily_count_bloc.dart';

abstract class DailyCountState extends Equatable {
  const DailyCountState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class DailyCountLoadInProgress extends DailyCountState {}

class DailyCountLoadSuccess extends DailyCountState {
  final List<StateDailyCount> dailyCounts;

  const DailyCountLoadSuccess([this.dailyCounts = const []]);

  @override
  List<Object> get props => [dailyCounts];
}

class DailyCountLoadFailure extends DailyCountState {
  final String message;

  DailyCountLoadFailure({this.message});
}

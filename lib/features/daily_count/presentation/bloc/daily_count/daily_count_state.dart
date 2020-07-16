part of 'daily_count_bloc.dart';

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

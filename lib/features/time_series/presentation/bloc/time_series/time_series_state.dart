part of 'time_series_bloc.dart';

abstract class TimeSeriesState extends Equatable {
  const TimeSeriesState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class TimeSeriesLoadInProgress extends TimeSeriesState {}

class TimeSeriesLoadSuccess extends TimeSeriesState {
  final List<StateTimeSeries> timeSeries;

  const TimeSeriesLoadSuccess([this.timeSeries = const []]);

  @override
  List<Object> get props => [timeSeries];
}

class TimeSeriesLoadFailure extends TimeSeriesState {
  final String message;

  TimeSeriesLoadFailure({this.message});
}

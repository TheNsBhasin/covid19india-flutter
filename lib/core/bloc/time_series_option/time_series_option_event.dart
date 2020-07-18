part of 'time_series_option_bloc.dart';

abstract class TimeSeriesOptionEvent extends Equatable {
  const TimeSeriesOptionEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class TimeSeriesOptionChanged extends TimeSeriesOptionEvent {
  final TimeSeriesOption option;

  const TimeSeriesOptionChanged({this.option});

  @override
  List<Object> get props => [option];
}

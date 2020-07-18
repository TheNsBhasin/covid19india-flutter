part of 'time_series_bloc.dart';

abstract class TimeSeriesEvent extends Equatable {
  const TimeSeriesEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadTimeSeries extends TimeSeriesEvent {
  final bool forced;
  final bool cache;

  LoadTimeSeries({this.forced: false, this.cache: true});

  @override
  List<Object> get props => [forced, cache];
}

class UpdateTimeSeries extends TimeSeriesEvent {
  final bool forced;
  final bool cache;
  final MapCodes mapCode;

  UpdateTimeSeries({this.forced: false, this.cache: true, this.mapCode});

  @override
  List<Object> get props => [forced, cache, mapCode];
}

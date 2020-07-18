part of 'time_series_chart_type_bloc.dart';

abstract class TimeSeriesChartTypeEvent extends Equatable {
  const TimeSeriesChartTypeEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class TimeSeriesChartTypeChanged extends TimeSeriesChartTypeEvent {
  final TimeSeriesChartType chartType;

  const TimeSeriesChartTypeChanged({this.chartType});

  @override
  List<Object> get props => [chartType];
}

part of 'time_series_chart_bloc.dart';

abstract class TimeSeriesChartEvent extends Equatable {
  const TimeSeriesChartEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class TimeSeriesChartScaleChanged extends TimeSeriesChartEvent {
  final bool isLog;
  final bool isUniform;

  const TimeSeriesChartScaleChanged({this.isLog, this.isUniform});

  @override
  List<Object> get props => [isLog, isUniform];
}

class TimeSeriesChartTypeChanged extends TimeSeriesChartEvent {
  final TimeSeriesChartType chartType;

  const TimeSeriesChartTypeChanged({this.chartType});

  @override
  List<Object> get props => [chartType];
}

class TimeSeriesOptionChanged extends TimeSeriesChartEvent {
  final TimeSeriesOption option;

  const TimeSeriesOptionChanged({this.option});

  @override
  List<Object> get props => [option];
}

part of 'time_series_chart_bloc.dart';

class TimeSeriesChartState extends Equatable {
  final bool isLog;
  final bool isUniform;

  final TimeSeriesChartType chartType;

  final TimeSeriesOption option;

  const TimeSeriesChartState(
      {this.isLog, this.isUniform, this.chartType, this.option});

  TimeSeriesChartState copyWith(
      {bool isLog,
      bool isUniform,
      TimeSeriesChartType chartType,
      TimeSeriesOption option}) {
    return new TimeSeriesChartState(
      isLog: isLog ?? this.isLog,
      isUniform: isUniform ?? this.isUniform,
      chartType: chartType ?? this.chartType,
      option: option ?? this.option,
    );
  }

  @override
  List<Object> get props => [isLog, isUniform, chartType, option];

  @override
  bool get stringify => true;
}

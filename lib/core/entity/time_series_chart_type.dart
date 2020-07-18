enum TimeSeriesChartType {
  total,
  delta,
}

extension TimeSeriesChartTypeExtension on TimeSeriesChartType {
  String get name {
    switch (this) {
      case TimeSeriesChartType.total:
        return 'Cumulative';
      case TimeSeriesChartType.delta:
        return 'Daily';
      default:
        return null;
    }
  }
}

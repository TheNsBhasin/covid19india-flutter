enum TimeSeriesOption {
  beginning,
  month,
  two_weeks,
}

extension TimeSeriesOptionExtension on TimeSeriesOption {
  String get name {
    switch (this) {
      case TimeSeriesOption.beginning:
        return 'Beginning';
      case TimeSeriesOption.month:
        return '1 Month';
      case TimeSeriesOption.two_weeks:
        return '2 Weeks';
      default:
        return null;
    }
  }
}

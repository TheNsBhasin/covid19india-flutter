enum StatisticType { total, delta }

extension StatisticTypeExtension on StatisticType {
  String get name {
    switch (this) {
      case StatisticType.total:
        return 'total';
      case StatisticType.delta:
        return 'delta';
      default:
        return null;
    }
  }
}

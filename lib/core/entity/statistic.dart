enum Statistic {
  confirmed,
  active,
  recovered,
  deceased,
  tested,
  migrated,
}

extension StatisticExtension on Statistic {
  String get name {
    switch (this) {
      case Statistic.confirmed:
        return 'confirmed';
      case Statistic.active:
        return 'active';
      case Statistic.recovered:
        return 'recovered';
      case Statistic.deceased:
        return 'deceased';
      case Statistic.tested:
        return 'tested';
      case Statistic.migrated:
        return 'migrated';
      default:
        return null;
    }
  }
}

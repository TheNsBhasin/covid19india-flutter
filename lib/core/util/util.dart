import 'package:covid19india/core/entity/statistic.dart';
import 'package:covid19india/core/entity/statistic_type.dart';
import 'package:covid19india/core/entity/stats.dart';

int getStatisticValue(Stats data, Statistic statistic) {
  if (statistic == Statistic.confirmed) {
    return data.confirmed;
  } else if (statistic == Statistic.active) {
    return data.active;
  } else if (statistic == Statistic.recovered) {
    return data.recovered;
  } else if (statistic == Statistic.deceased) {
    return data.deceased;
  } else if (statistic == Statistic.tested) {
    return data.tested;
  } else if (statistic == Statistic.migrated) {
    return data.migrated;
  }

  return data.confirmed;
}

int getStatistics(dynamic data, StatisticType type, Statistic statistic,
    {perMillion: false}) {
  int count = getStatisticValue(getStatisticType(data, type), statistic);

  if (perMillion && data.metadata.population == null) {
    return 0;
  }

  return perMillion ? (1000000 * count) ~/ data.metadata.population : count;
}

Stats getStatisticType(dynamic data, StatisticType type) {
  if (type == StatisticType.delta) {
    return data.delta;
  } else {
    return data.total;
  }
}

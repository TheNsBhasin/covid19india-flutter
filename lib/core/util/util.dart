import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/stats.dart';

int getStatisticValue(Stats data, STATISTIC statistic) {
  if (statistic == STATISTIC.CONFIRMED) {
    return data.confirmed;
  } else if (statistic == STATISTIC.ACTIVE) {
    return data.active;
  } else if (statistic == STATISTIC.RECOVERED) {
    return data.recovered;
  } else if (statistic == STATISTIC.DECEASED) {
    return data.deceased;
  } else if (statistic == STATISTIC.TESTED) {
    return data.tested;
  } else if (statistic == STATISTIC.MIGRATED) {
    return data.migrated;
  }

  return data.confirmed;
}

int getStatistics(dynamic data, STATISTIC_TYPE type, STATISTIC statistic,
    {perMillion: false}) {
  int count = getStatisticValue(getStatisticType(data, type), statistic);

  if (perMillion && data.metadata.population == null) {
    return 0;
  }

  return perMillion ? (1000000 * count) ~/ data.metadata.population : count;
}

Stats getStatisticType(dynamic data, STATISTIC_TYPE type) {
  if (type == STATISTIC_TYPE.DELTA) {
    return data.delta;
  } else {
    return data.total;
  }
}

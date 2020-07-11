import 'package:covid19india/core/entity/stats.dart';

int getStatisticValue(Stats data, statistic) {
  if (statistic == 'confirmed') {
    return data.confirmed;
  } else if (statistic == 'active') {
    return data.active;
  } else if (statistic == 'recovered') {
    return data.recovered;
  } else if (statistic == 'deceased') {
    return data.deceased;
  } else if (statistic == 'tested') {
    return data.tested;
  } else if (statistic == 'migrated') {
    return data.migrated;
  }

  return data.confirmed;
}

int getStatistics(dynamic data, String type, String statistic,
    {perMillion: false}) {
  int count = getStatisticValue(getStatisticType(data, type), statistic);

  if (perMillion && data.metadata.population == null) {
    return 0;
  }

  return perMillion ? (1000000 * count) ~/ data.metadata.population : count;
}

Stats getStatisticType(dynamic data, String type) {
  if (type == 'delta') {
    return data.delta;
  } else {
    return data.total;
  }
}

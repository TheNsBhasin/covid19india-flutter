import 'package:intl/intl.dart';

class Endpoints {
  static const String DAILY_COUNTS =
      'https://api.covid19india.org/v4/min/data.min.json';

  static const String TIME_SERIES =
      'https://api.covid19india.org/v4/min/timeseries.min.json';

  static const String UPDATE_LOGS =
      'https://api.covid19india.org/updatelog/log.json';

  static String dailyCount({DateTime date}) {
    String dateString = new DateFormat("yyyy-MM-dd").format(date);
    return "https://api.covid19india.org/v4/min/data-$dateString.min.json";
  }

  static String timeSeries({String stateCode}) {
    return "https://api.covid19india.org/v4/min/timeseries-$stateCode.min.json";
  }
}

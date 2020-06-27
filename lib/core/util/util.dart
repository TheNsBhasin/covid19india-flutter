import 'package:covid19india/features/daily_count/domain/entities/stats.dart';

class Utilities {
  static double scaleTime(DateTime start, DateTime end, DateTime current) {
    int total = end.difference(start).inDays;
    int diff = current.difference(start).inDays;

    return (diff / total) * 100.0;
  }

  static double scaleLinear(int start, int end, int current) {
    int total = end - start;
    int diff = current - start;

    return (diff / total) * 100.0;
  }
}

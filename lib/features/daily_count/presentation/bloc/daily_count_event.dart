import 'package:equatable/equatable.dart';
import 'package:covid19india/core/util/extensions.dart';

abstract class DailyCountEvent extends Equatable {}

class GetDailyCountData extends DailyCountEvent {
  final bool forced;
  final bool cache;
  final DateTime date;

  GetDailyCountData({this.forced = false, DateTime date})
      : this.date = (date == null ? DateTime.now() : date),
        this.cache = (date == null ? true : date.isToday());

  @override
  List<Object> get props => [forced, cache, date];

  @override
  String toString() {
    return "GetDailyCountData {forced: $forced, cache: $cache, date: $date}";
  }
}

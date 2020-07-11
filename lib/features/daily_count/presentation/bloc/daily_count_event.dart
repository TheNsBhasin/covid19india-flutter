import 'package:equatable/equatable.dart';

abstract class DailyCountEvent extends Equatable {}

class GetDailyCountData extends DailyCountEvent {
  final bool forced;
  final bool cache;
  final DateTime date;

  GetDailyCountData({this.forced = false, this.cache = true, this.date});

  @override
  List<Object> get props => [forced, cache, date];

  @override
  bool get stringify => true;
}

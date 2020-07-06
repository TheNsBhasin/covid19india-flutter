import 'package:equatable/equatable.dart';

abstract class DailyCountEvent extends Equatable {}

class GetDailyCountData extends DailyCountEvent {
  final bool forced;

  GetDailyCountData({this.forced = false});

  @override
  List<Object> get props => [forced];
}

import 'package:equatable/equatable.dart';

abstract class TimeSeriesEvent extends Equatable {}

class GetTimeSeriesData extends TimeSeriesEvent {
  final bool forced;
  final bool cache;

  GetTimeSeriesData({this.forced = false, this.cache = true});

  @override
  List<Object> get props => [forced, cache];

  @override
  bool get stringify => true;
}

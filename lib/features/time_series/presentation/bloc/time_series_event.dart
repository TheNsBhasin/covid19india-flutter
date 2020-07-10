import 'package:equatable/equatable.dart';

abstract class TimeSeriesEvent extends Equatable {}

class GetTimeSeriesData extends TimeSeriesEvent {
  final bool forced;

  GetTimeSeriesData({this.forced = false});

  @override
  List<Object> get props => [forced];

  @override
  String toString() {
    return "GetTimeSeriesData {forced: $forced}";
  }
}

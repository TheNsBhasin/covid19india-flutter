import 'package:equatable/equatable.dart';

abstract class StateTimeSeriesEvent extends Equatable {}

class GetTimeSeriesData extends StateTimeSeriesEvent {
  final bool forced;
  final bool cache;
  final String stateCode;

  GetTimeSeriesData(
      {this.forced = false, this.cache = true, this.stateCode});

  @override
  List<Object> get props => [forced, cache, stateCode];

  @override
  bool get stringify => true;
}

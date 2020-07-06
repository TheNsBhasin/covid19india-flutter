import 'package:equatable/equatable.dart';

abstract class UpdateLogEvent extends Equatable {}

class GetUpdateLogData extends UpdateLogEvent {
  final bool forced;

  GetUpdateLogData({this.forced = false});

  @override
  List<Object> get props => [forced];
}

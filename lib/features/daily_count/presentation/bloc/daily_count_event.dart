import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class DailyCountEvent extends Equatable {}

class GetDailyCountData extends DailyCountEvent {
  final bool forced;

  GetDailyCountData({this.forced = false});

  @override
  List<Object> get props => [];
}

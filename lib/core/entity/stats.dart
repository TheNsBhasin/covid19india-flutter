import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Stats extends Equatable {
  final int confirmed;
  final int recovered;
  final int deceased;
  final int tested;
  final int migrated;

  Stats(
      {@required this.confirmed,
      @required this.recovered,
      @required this.deceased,
      @required this.tested,
      @required this.migrated});

  @override
  List<Object> get props => [confirmed, recovered, deceased, tested, migrated];

  int get active => confirmed - recovered - deceased;

  @override
  bool get stringify => true;
}

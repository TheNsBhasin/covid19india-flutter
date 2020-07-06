import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UpdateLog extends Equatable {
  final String update;
  final DateTime timestamp;

  UpdateLog({@required this.update, @required this.timestamp});

  @override
  List<Object> get props => [update, timestamp];

  @override
  bool get stringify => true;
}

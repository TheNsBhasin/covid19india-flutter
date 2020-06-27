import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Metadata extends Equatable {
  final String lastUpdated;
  final String notes;
  final Map<String, dynamic> tested;

  Metadata(
      {@required this.lastUpdated,
      @required this.notes,
      @required this.tested});

  @override
  List<Object> get props => [lastUpdated, notes, tested];

  @override
  bool get stringify => true;
}

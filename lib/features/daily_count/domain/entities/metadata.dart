import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Metadata extends Equatable {
  final String lastUpdated;
  final int population;
  final String notes;
  final Map<String, dynamic> tested;

  Metadata(
      {@required this.lastUpdated,
      @required this.population,
      @required this.notes,
      @required this.tested});

  @override
  List<Object> get props => [lastUpdated, population, notes, tested];

  @override
  bool get stringify => true;
}

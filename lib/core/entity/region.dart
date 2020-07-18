import 'package:covid19india/core/entity/map_codes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Region extends Equatable {
  final MapCodes stateCode;
  final String districtName;

  const Region({@required this.stateCode, this.districtName});

  @override
  List<Object> get props => [stateCode, districtName];

  @override
  bool get stringify => true;
}

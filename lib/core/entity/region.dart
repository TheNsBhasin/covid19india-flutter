import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Region extends Equatable {
  final String stateCode;
  final String districtName;

  Region({@required this.stateCode, this.districtName});

  @override
  List<Object> get props => [stateCode, districtName];

  @override
  bool get stringify => true;
}

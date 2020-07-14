import 'package:covid19india/core/entity/region.dart';

class RegionModel extends Region {
  RegionModel({String stateCode, String districtName})
      : super(stateCode: stateCode, districtName: districtName);

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      stateCode: json['state_code'],
      districtName: json['district_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state_code': stateCode,
      'district_name': districtName,
    };
  }
}

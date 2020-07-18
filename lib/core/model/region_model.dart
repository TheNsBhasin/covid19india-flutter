import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/region.dart';

class RegionModel extends Region {
  RegionModel({MapCodes stateCode, String districtName})
      : super(stateCode: stateCode, districtName: districtName);

  RegionModel copyWith({MapCodes stateCode, String districtName}) {
    return RegionModel(
        stateCode: stateCode ?? this.stateCode,
        districtName: districtName ?? this.districtName);
  }

  factory RegionModel.fromEntity(Region entity) {
    return RegionModel(
        stateCode: entity.stateCode, districtName: entity.districtName);
  }

  Region toEntity() {
    return Region(stateCode: stateCode, districtName: districtName);
  }

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      stateCode: (json['state_code'] as String).toMapCode(),
      districtName: json['district_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state_code': stateCode.key,
      'district_name': districtName,
    };
  }
}

import 'package:covid19india/core/entity/map_type.dart';

enum MapCodes {
  TT,
  AN,
  AP,
  AR,
  AS,
  BR,
  CH,
  CT,
  DL,
  DN,
  GA,
  GJ,
  HP,
  HR,
  JH,
  JK,
  KA,
  KL,
  LA,
  LD,
  MH,
  ML,
  MN,
  MP,
  MZ,
  NL,
  OR,
  PB,
  PY,
  RJ,
  SK,
  TG,
  TN,
  TR,
  UN,
  UP,
  UT,
  WB
}

extension EnumParser on String {
  MapCodes toMapCode() {
    return MapCodes.values.firstWhere((e) => e.toString() == 'MapCodes.$this',
        orElse: () => null); //return null if not found
  }
}

extension MapCodesExtension on MapCodes {
  String get name {
    switch (this) {
      case MapCodes.TT:
        return "India";
      case MapCodes.AN:
        return "Andaman and Nicobar Islands";
      case MapCodes.AP:
        return "Andhra Pradesh";
      case MapCodes.AR:
        return "Arunachal Pradesh";
      case MapCodes.AS:
        return "Assam";
      case MapCodes.BR:
        return "Bihar";
      case MapCodes.CH:
        return "Chandigarh";
      case MapCodes.CT:
        return "Chhattisgarh";
      case MapCodes.DL:
        return "Delhi";
      case MapCodes.DN:
        return "Dadra and Nagar Haveli and Daman and Diu";
      case MapCodes.GA:
        return "Goa";
      case MapCodes.GJ:
        return "Gujarat";
      case MapCodes.HP:
        return "Himachal Pradesh";
      case MapCodes.HR:
        return "Haryana";
      case MapCodes.JH:
        return "Jharkhand";
      case MapCodes.JK:
        return "Jammu and Kashmir";
      case MapCodes.KA:
        return "Karnataka";
      case MapCodes.KL:
        return "Kerala";
      case MapCodes.LA:
        return "Ladakh";
      case MapCodes.LD:
        return "Lakshadweep";
      case MapCodes.MH:
        return "Maharashtra";
      case MapCodes.ML:
        return "Meghalaya";
      case MapCodes.MN:
        return "Manipur";
      case MapCodes.MP:
        return "Madhya Pradesh";
      case MapCodes.MZ:
        return "Mizoram";
      case MapCodes.NL:
        return "Nagaland";
      case MapCodes.OR:
        return "Odisha";
      case MapCodes.PB:
        return "Punjab";
      case MapCodes.PY:
        return "Puducherry";
      case MapCodes.RJ:
        return "Rajasthan";
      case MapCodes.SK:
        return "Sikkim";
      case MapCodes.TG:
        return "Telangana";
      case MapCodes.TN:
        return "Tamil Nadu";
      case MapCodes.TR:
        return "Tripura";
      case MapCodes.UP:
        return "Uttar Pradesh";
      case MapCodes.UT:
        return "Uttarakhand";
      case MapCodes.WB:
        return "West Bengal";
      default:
        return "Unassigned";
    }
  }

  String get key {
    switch (this) {
      case MapCodes.TT:
        return "TT";
      case MapCodes.AN:
        return "AN";
      case MapCodes.AP:
        return "AP";
      case MapCodes.AR:
        return "AR";
      case MapCodes.AS:
        return "AS";
      case MapCodes.BR:
        return "BR";
      case MapCodes.CH:
        return "CH";
      case MapCodes.CT:
        return "CT";
      case MapCodes.DL:
        return "DL";
      case MapCodes.DN:
        return "DN";
      case MapCodes.GA:
        return "GA";
      case MapCodes.GJ:
        return "GJ";
      case MapCodes.HP:
        return "HP";
      case MapCodes.HR:
        return "HR";
      case MapCodes.JH:
        return "JH";
      case MapCodes.JK:
        return "JK";
      case MapCodes.KA:
        return "KA";
      case MapCodes.KL:
        return "KL";
      case MapCodes.LA:
        return "LA";
      case MapCodes.LD:
        return "LD";
      case MapCodes.MH:
        return "MH";
      case MapCodes.ML:
        return "ML";
      case MapCodes.MN:
        return "MN";
      case MapCodes.MP:
        return "MP";
      case MapCodes.MZ:
        return "MZ";
      case MapCodes.NL:
        return "NL";
      case MapCodes.OR:
        return "OR";
      case MapCodes.PB:
        return "PB";
      case MapCodes.PY:
        return "PY";
      case MapCodes.RJ:
        return "RJ";
      case MapCodes.SK:
        return "SK";
      case MapCodes.TG:
        return "TG";
      case MapCodes.TN:
        return "TN";
      case MapCodes.TR:
        return "TR";
      case MapCodes.UP:
        return "UP";
      case MapCodes.UT:
        return "UT";
      case MapCodes.WB:
        return "WB";
      default:
        return "UN";
    }
  }

  MapType get mapType {
    switch (this) {
      case MapCodes.TT:
        return MapType.country;
      default:
        return MapType.state;
    }
  }
}

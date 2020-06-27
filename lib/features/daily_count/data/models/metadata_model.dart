import 'package:covid19india/features/daily_count/domain/entities/metadata.dart';

class MetadataModel extends Metadata {
  MetadataModel({String lastUpdated, String notes, Map<String, dynamic> tested})
      : super(lastUpdated: lastUpdated, notes: notes, tested: tested);

  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel(
        lastUpdated: json['last_updated'],
        notes: json['notes'],
        tested: json['tested']);
  }

  Map<String, dynamic> toJson() {
    return {'last_updated': lastUpdated, 'notes': notes, 'tested': tested};
  }
}

import 'package:covid19india/features/daily_count/domain/entities/metadata.dart';

class MetadataModel extends Metadata {
  MetadataModel(
      {String lastUpdated,
      int population,
      String notes,
      Map<String, dynamic> tested})
      : super(
            lastUpdated: lastUpdated,
            population: population,
            notes: notes,
            tested: tested);

  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel(
        lastUpdated: json['last_updated'],
        population: json['population'],
        notes: json['notes'],
        tested: json['tested']);
  }

  Map<String, dynamic> toJson() {
    return {
      'last_updated': lastUpdated,
      'population': population,
      'notes': notes,
      'tested': tested
    };
  }
}

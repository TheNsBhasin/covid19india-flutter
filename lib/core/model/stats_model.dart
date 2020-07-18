import 'package:covid19india/core/entity/stats.dart';

class StatsModel extends Stats {
  StatsModel(
      {int confirmed = 0,
      int recovered = 0,
      int deceased = 0,
      int tested = 0,
      int migrated = 0})
      : super(
            confirmed: confirmed,
            recovered: recovered,
            deceased: deceased,
            tested: tested,
            migrated: migrated);

  StatsModel copyWith(
      {int confirmed, int recovered, int deceased, int tested, int migrated}) {
    return StatsModel(
        confirmed: confirmed ?? this.confirmed,
        recovered: recovered ?? this.recovered,
        deceased: deceased ?? this.deceased,
        tested: tested ?? this.tested,
        migrated: migrated ?? this.migrated);
  }

  factory StatsModel.fromEntity(Stats entity) {
    return StatsModel(
        confirmed: entity.confirmed,
        recovered: entity.recovered,
        deceased: entity.deceased,
        tested: entity.tested,
        migrated: entity.migrated);
  }

  Stats toEntity() {
    return Stats(
        confirmed: this.confirmed,
        recovered: this.recovered,
        deceased: this.deceased,
        tested: this.tested,
        migrated: this.migrated);
  }

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
        confirmed: json['confirmed'],
        recovered: json['recovered'],
        deceased: json['deceased'],
        tested: json['tested'],
        migrated: json['migrated']);
  }

  Map<String, dynamic> toJson() {
    return {
      'confirmed': confirmed,
      'recovered': recovered,
      'deceased': deceased,
      'tested': tested,
      'migrated': migrated
    };
  }
}

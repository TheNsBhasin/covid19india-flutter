import 'package:covid19india/features/daily_count/domain/entities/stats.dart';

class StatsModel extends Stats {
  StatsModel(
      {int confirmed = 0, int recovered = 0, int deceased = 0, int tested = 0})
      : super(
            confirmed: confirmed,
            recovered: recovered,
            deceased: deceased,
            tested: tested);

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
        confirmed: json['confirmed'],
        recovered: json['recovered'],
        deceased: json['deceased'],
        tested: json['tested']);
  }

  Map<String, dynamic> toJson() {
    return {
      'confirmed': confirmed,
      'recovered': recovered,
      'deceased': deceased,
      'tested': tested
    };
  }
}

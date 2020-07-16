part of 'page_bloc.dart';

class StatePageState extends Equatable {
  final DateTime date;
  final STATISTIC statistic;
  final Region region;
  final Region regionHighlighted;

  StatePageState(
      {@required this.date,
      @required this.statistic,
      @required this.region,
      @required this.regionHighlighted});

  StatePageState copyWith({
    DateTime date,
    STATISTIC statistic,
    Region region,
    Region regionHighlighted,
  }) {
    return StatePageState(
      date: date ?? this.date,
      statistic: statistic ?? this.statistic,
      region: region ?? this.region,
      regionHighlighted: regionHighlighted ?? this.regionHighlighted,
    );
  }

  @override
  List<Object> get props => [date, statistic, region, regionHighlighted];

  @override
  bool get stringify => true;
}

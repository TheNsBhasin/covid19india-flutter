part of 'page_bloc.dart';

class HomePageState extends Equatable {
  final DateTime date;
  final STATISTIC statistic;
  final Region regionHighlighted;

  HomePageState(
      {@required this.date,
      @required this.statistic,
      @required this.regionHighlighted});

  HomePageState copyWith({
    DateTime date,
    STATISTIC statistic,
    Region regionHighlighted,
  }) {
    return HomePageState(
      date: date ?? this.date,
      statistic: statistic ?? this.statistic,
      regionHighlighted: regionHighlighted ?? this.regionHighlighted,
    );
  }

  @override
  List<Object> get props => [date, statistic, regionHighlighted];

  @override
  bool get stringify => true;
}

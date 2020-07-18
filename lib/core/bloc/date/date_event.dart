part of 'date_bloc.dart';

abstract class DateEvent extends Equatable {
  const DateEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class DateChanged extends DateEvent {
  final DateTime date;

  DateChanged({this.date});

  @override
  List<Object> get props => [date];
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'date_event.dart';

class DateBloc extends Bloc<DateEvent, DateTime> {
  DateBloc({DateTime date}) : super(date);

  @override
  Stream<DateTime> mapEventToState(
    DateEvent event,
  ) async* {
    if (event is DateChanged) {
      yield event.date;
    }
  }
}

import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part "page_event.dart";

part "page_state.dart";

class StatePageBloc extends Bloc<StatePageEvent, StatePageState> {
  Region region;

  StatePageBloc({this.region});

  @override
  StatePageState get initialState => StatePageState(
      date: DateTime.now(),
      statistic: STATISTIC.CONFIRMED,
      region: region,
      regionHighlighted: region);

  @override
  Stream<StatePageState> mapEventToState(StatePageEvent event) async* {
    print('StatePageBloc: $event');

    if (event is DateChanged) {
      yield state.copyWith(date: event.date);
    } else if (event is StatisticChanged) {
      yield state.copyWith(statistic: event.statistic);
    } else if (event is RegionChanged) {
      yield state.copyWith(region: event.region);
    } else if (event is RegionHighlightedChanged) {
      yield state.copyWith(regionHighlighted: event.regionHighlighted);
    }
  }
}

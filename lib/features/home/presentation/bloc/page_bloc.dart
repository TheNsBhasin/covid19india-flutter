import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part "page_event.dart";
part "page_state.dart";

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  @override
  HomePageState get initialState => HomePageState(
      date: DateTime.now(),
      statistic: STATISTIC.CONFIRMED,
      regionHighlighted: Region(stateCode: 'TT', districtName: null));

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    print('HomeBloc: $event');

    if (event is DateChanged) {
      yield state.copyWith(date: event.date);
    } else if (event is StatisticChanged) {
      yield state.copyWith(statistic: event.statistic);
    } else if (event is RegionHighlightedChanged) {
      yield state.copyWith(regionHighlighted: event.regionHighlighted);
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'region_highlighted_event.dart';

class RegionHighlightedBloc extends Bloc<RegionHighlightedEvent, Region> {
  RegionHighlightedBloc({@required Region region}) : super(region);

  @override
  Stream<Region> mapEventToState(
    RegionHighlightedEvent event,
  ) async* {
    if (event is RegionHighlightedChanged) {
      yield event.regionHighlighted;
    }
  }
}

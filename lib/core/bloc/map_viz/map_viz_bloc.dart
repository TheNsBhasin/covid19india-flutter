import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/map_viz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'map_viz_event.dart';

class MapVizBloc extends Bloc<MapVizEvent, MapViz> {
  MapVizBloc({@required MapViz mapViz}) : super(mapViz);

  @override
  Stream<MapViz> mapEventToState(
    MapVizEvent event,
  ) async* {
    if (event is MapVizChanged) {
      yield event.mapViz;
    }
  }
}

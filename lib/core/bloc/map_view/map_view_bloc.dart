import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/map_view.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'map_view_event.dart';

class MapViewBloc extends Bloc<MapViewEvent, MapView> {
  MapViewBloc({@required MapView mapView}) : super(mapView);

  @override
  Stream<MapView> mapEventToState(
    MapViewEvent event,
  ) async* {
    if (event is MapViewChanged) {
      yield event.mapView;
    }
  }
}

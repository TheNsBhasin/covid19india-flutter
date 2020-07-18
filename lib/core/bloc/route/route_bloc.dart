import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'route_event.dart';

part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(HomeRoute());

  @override
  Stream<RouteState> mapEventToState(
    RouteEvent event,
  ) async* {
    if (event is NavigateToHomePage) {
      yield HomeRoute();
    } else if (event is NavigateToStatePage) {
      yield StateRoute(region: event.region);
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tab_event.dart';

class TabBloc extends Bloc<TabEvent, StateTab> {
  TabBloc() : super(StateTab.map);

  @override
  Stream<StateTab> mapEventToState(
    TabEvent event,
  ) async* {
    if (event is TabChanged) {
      yield event.tab;
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid19india/core/entity/home_tab.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tab_event.dart';

class TabBloc extends Bloc<TabEvent, HomeTab> {
  TabBloc() : super(HomeTab.table);

  @override
  Stream<HomeTab> mapEventToState(
    TabEvent event,
  ) async* {
    if (event is TabChanged) {
      yield event.tab;
    }
  }
}

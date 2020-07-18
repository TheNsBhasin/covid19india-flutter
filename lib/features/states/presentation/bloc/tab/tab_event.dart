part of 'tab_bloc.dart';

abstract class TabEvent extends Equatable {
  const TabEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class TabChanged extends TabEvent {
  final StateTab tab;

  const TabChanged({@required this.tab});

  @override
  List<Object> get props => [tab];
}

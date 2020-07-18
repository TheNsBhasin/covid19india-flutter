part of 'route_bloc.dart';

abstract class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class NavigateToHomePage extends RouteEvent {}

class NavigateToStatePage extends RouteEvent {
  final Region region;

  NavigateToStatePage({@required this.region});

  @override
  List<Object> get props => [region];
}

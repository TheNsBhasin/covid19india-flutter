part of 'route_bloc.dart';

abstract class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class HomeRoute extends RouteState {}

class StateRoute extends RouteState {
  final Region region;

  StateRoute({@required this.region});

  @override
  List<Object> get props => [region];
}

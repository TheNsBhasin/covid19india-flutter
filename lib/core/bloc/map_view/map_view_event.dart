part of 'map_view_bloc.dart';

abstract class MapViewEvent extends Equatable {
  const MapViewEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class MapViewChanged extends MapViewEvent {
  final MapView mapView;

  const MapViewChanged({this.mapView});

  @override
  List<Object> get props => [mapView];
}

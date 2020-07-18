part of 'map_viz_bloc.dart';

abstract class MapVizEvent extends Equatable {
  const MapVizEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class MapVizChanged extends MapVizEvent {
  final MapViz mapViz;

  const MapVizChanged({this.mapViz});

  @override
  List<Object> get props => [mapViz];
}

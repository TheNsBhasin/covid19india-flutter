part of 'region_highlighted_bloc.dart';

@immutable
abstract class RegionHighlightedEvent extends Equatable {
  const RegionHighlightedEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class RegionHighlightedChanged extends RegionHighlightedEvent {
  final Region regionHighlighted;

  const RegionHighlightedChanged({this.regionHighlighted});

  @override
  List<Object> get props => [regionHighlighted];
}

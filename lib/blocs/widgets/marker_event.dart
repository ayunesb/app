part of 'marker_bloc.dart';

@immutable
abstract class MarkerEvent {}

class MarkerSelectedEvent extends MarkerEvent {
  final LatLng property_location;
  final int marker_position;

  MarkerSelectedEvent(this.property_location, this.marker_position);
}

class PropertyCardSelectedEvent extends MarkerEvent {
  final LatLng property_location;

  PropertyCardSelectedEvent(this.property_location);
}


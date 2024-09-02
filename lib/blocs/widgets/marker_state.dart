part of 'marker_bloc.dart';

@immutable
abstract class MarkerState {}

class MarkerInitial extends MarkerState {}

class MarkerSelectedSuccess extends MarkerState {
  final LatLng property_location;
  final int marker_position;
  MarkerSelectedSuccess(this.property_location, this.marker_position);
}

class PropertyCardSelectedSuccess extends MarkerState {
  final LatLng property_location;
  PropertyCardSelectedSuccess(this.property_location);
}

part of 'location_bloc.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class CurrentLocationGranted extends LocationState {
  final LatLng current_location;

  CurrentLocationGranted(this.current_location);
}

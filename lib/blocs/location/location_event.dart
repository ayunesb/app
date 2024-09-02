part of 'location_bloc.dart';

abstract class LocationEvent {}

class LocationLoad extends LocationEvent {
  BuildContext context;
  LocationLoad(this.context);
}

class LocationSuccess extends LocationEvent {
  final LatLng current_location;

  LocationSuccess(this.current_location);
}

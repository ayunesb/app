part of 'amenity_bloc.dart';

@immutable
abstract class AmenitiesEvent {}

class AmenitiesInitialEvent extends AmenitiesEvent {
  AmenitiesInitialEvent();
}

class AmenitiesLoadedEvent extends AmenitiesEvent {
  final List<PropertyEnum> allAmenities;
  AmenitiesLoadedEvent({required this.allAmenities});
}

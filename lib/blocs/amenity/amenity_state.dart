part of 'amenity_bloc.dart';


abstract class AmenitiesState {}

class AmenitiesInitialState extends AmenitiesState {}

class AmenitiesLoadSuccessState extends AmenitiesState {
  late List<PropertyEnum> allAmenities;
  AmenitiesLoadSuccessState(this.allAmenities) {}
}

class AmenitiesLoadFailureState extends AmenitiesState {}
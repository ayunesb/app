part of 'property_bloc.dart';

abstract class PropertyState {}

class PropertyInitialState extends PropertyState {}

class PropertyLoadSuccessState extends PropertyState {
  late Property property;
  PropertyLoadSuccessState(this.property) {}
}

class PropertyLoadFailureState extends PropertyState {}
part of 'property_bloc.dart';

@immutable
abstract class PropertyEvent {}

class PropertyLoadingEvent extends PropertyEvent {
  final String propertyId;
  PropertyLoadingEvent({required this.propertyId} );
}

class PropertyInitialEvent extends PropertyEvent {
  PropertyInitialEvent();
}
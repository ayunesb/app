part of 'property_list_bloc.dart';

@immutable
abstract class PropertyListEvent {}

class PropertyListInitialEvent extends PropertyListEvent {
  final ActiveType active;
  PropertyListInitialEvent({ this.active = ActiveType.active} );
}

class PropertyListLoadedEvent extends PropertyListEvent {
  final PropertyList propertyList;
  PropertyListLoadedEvent({required this.propertyList});
}
part of 'filters_bloc.dart';

@immutable
abstract class FiltersEvent {}
class FiltersInitialEvent extends FiltersEvent {
  final BuildContext context;
  FiltersInitialEvent(this.context);
}

class FiltersLoadedEvent extends FiltersEvent {
  final PropertyFilters propertyFilters;
  FiltersLoadedEvent({required this.propertyFilters});
}

class FiltersChangedEvent extends FiltersEvent {
  final PropertyFilters propertyFilters;
  FiltersChangedEvent({required this.propertyFilters});
}
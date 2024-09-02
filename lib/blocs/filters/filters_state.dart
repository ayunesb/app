part of 'filters_bloc.dart';

abstract class FiltersState {}

class FiltersInitialState extends FiltersState {}

class FiltersLoadSuccessState extends FiltersState {
  late PropertyFilters propertyFilters;
  FiltersLoadSuccessState(this.propertyFilters) {}
}

class FiltersChangedState extends FiltersState {
  late PropertyFilters propertyFilters;
  FiltersChangedState(this.propertyFilters) {}
}

class FiltersLoadFailureState extends FiltersState {}
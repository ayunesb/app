part of 'property_list_bloc.dart';

abstract class PropertyListState {}

class PropertyListInitialState extends PropertyListState {}

class PropertyListLoadSuccessState extends PropertyListState {
  late PropertyList propertyList;
  PropertyListLoadSuccessState(this.propertyList) {}
}

class PropertyListLoadFailureState extends PropertyListState {
  final String errorMsg;
  late StackTrace? stacktrace;
  PropertyListLoadFailureState({required this.errorMsg, this.stacktrace = null}) {}
}
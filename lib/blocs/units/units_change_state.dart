part of 'units_change_bloc.dart';

abstract class UnitsState {}

class UnitsInitial extends UnitsState {}

class UnitsSelectSuccess extends UnitsState {
  final UnitsOptions? units;

  UnitsSelectSuccess(this.units);
}

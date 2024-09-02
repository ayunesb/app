part of 'units_change_bloc.dart';

@immutable
abstract class UnitsEvent {}

class UnitsSelected extends UnitsEvent {
  final UnitsOptions? units;

  UnitsSelected({this.units = UnitsOptions.metric});
}

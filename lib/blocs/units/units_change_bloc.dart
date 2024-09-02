import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'units_change_event.dart';
part 'units_change_state.dart';

enum UnitsOptions { metric, imperial }

class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  UnitsOptions? selectedUnits = UnitsOptions.metric;

  UnitsBloc() : super(UnitsInitial()) {
    on<UnitsSelected>(_onUnitsChange);
  }

  void _onUnitsChange(UnitsSelected event, Emitter<UnitsState> emit) {
    selectedUnits = event.units;
    emit(UnitsSelectSuccess(event.units));
  }
}

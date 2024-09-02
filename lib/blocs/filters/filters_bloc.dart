import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:paradigm_mex/ui/widgets/property/filters.dart';

part 'filters_event.dart';
part 'filters_state.dart';

class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {
  late PropertyFilters _propertyFilters;
  FiltersBloc()
      : super(FiltersInitialState()) {
    _propertyFilters = PropertyFilters();
    on<FiltersEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(
      FiltersEvent event, Emitter<FiltersState> emit) async {
    if (event is FiltersInitialEvent) {
      try {
        await this._propertyFilters.initialize(event.context);
        emit(FiltersLoadSuccessState(this._propertyFilters));
      } catch (err) {
        emit(FiltersLoadFailureState());
      }
    } else if (event is FiltersChangedEvent) {
      emit(FiltersChangedState(this._propertyFilters));
    }

  }
}

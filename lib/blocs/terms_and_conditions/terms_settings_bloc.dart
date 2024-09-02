import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../../service/general_services.dart';

part 'terms_settings_event.dart';
part 'terms_settings_state.dart';


class TermsBloc extends Bloc<TermsEvent, TermsState> {
  TermsBloc() : super(TermsInitial()) {
    on<TermsEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(TermsEvent event, Emitter<TermsState> emit) async {
    if (event is TermsInitialEvent) {
      bool accepted = GeneralServices.getTerms();
      emit(TermsLoadedSuccess(accepted));
    }
    if (event is TermsUpdateEvent) {
      bool accepted = event.accepted;

      bool success = await GeneralServices.setTerms(accepted);
      emit(TermsUpdatedSuccess(accepted));
    }
  }
}

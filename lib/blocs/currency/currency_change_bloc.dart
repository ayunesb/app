import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'currency_change_event.dart';
part 'currency_change_state.dart';

enum CurrencyOptions { mxn, usd }

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyOptions? selectedCurrency = CurrencyOptions.mxn;

  CurrencyBloc() : super(CurrencyInitial()) {
    on<CurrencySelected>(_onCurrencyChange);
  }

  void _onCurrencyChange(CurrencySelected event, Emitter<CurrencyState> emit) {
    selectedCurrency = event.currency;
    emit(CurrencySelectSuccess(event.currency));
  }
}

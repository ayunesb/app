part of 'currency_change_bloc.dart';

abstract class CurrencyState {}

class CurrencyInitial extends CurrencyState {}

class CurrencySelectSuccess extends CurrencyState {
  final CurrencyOptions? currency;

  CurrencySelectSuccess(this.currency);
}

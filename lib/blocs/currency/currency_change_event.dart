part of 'currency_change_bloc.dart';

@immutable
abstract class CurrencyEvent {}

class CurrencySelected extends CurrencyEvent {
  final CurrencyOptions? currency;

  CurrencySelected({this.currency = CurrencyOptions.mxn});
}

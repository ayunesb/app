part of 'terms_settings_bloc.dart';

abstract class TermsState {}

class TermsInitial extends TermsState {}

class TermsLoadedSuccess extends TermsState {
  final bool accepted;
  TermsLoadedSuccess(this.accepted);
}
class TermsUpdatedSuccess extends TermsState {
  final bool accepted;
  TermsUpdatedSuccess(this.accepted);
}

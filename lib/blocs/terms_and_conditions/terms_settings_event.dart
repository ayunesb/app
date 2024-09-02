part of 'terms_settings_bloc.dart';

@immutable
abstract class TermsEvent {}

class TermsInitialEvent extends TermsEvent {
  TermsInitialEvent();
}

class TermsUpdateEvent extends TermsEvent {
  bool accepted;
  TermsUpdateEvent(this.accepted);
}
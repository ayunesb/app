part of 'language_change_bloc.dart';

abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageSelectSuccess extends LanguageState {
  final LanguageOptions? language;

  LanguageSelectSuccess(this.language);
}

part of 'language_change_bloc.dart';

@immutable
abstract class LanguageEvent {}

class LanguageSelected extends LanguageEvent {
  final LanguageOptions? language;

  LanguageSelected({this.language = LanguageOptions.english});
}

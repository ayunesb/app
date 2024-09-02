import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'language_change_event.dart';
part 'language_change_state.dart';

enum LanguageOptions { english, spanish }

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageOptions? selectedLanguage = LanguageOptions.english;

  LanguageBloc() : super(LanguageInitial()) {
    on<LanguageSelected>(_onLanguageChange);
  }

  void _onLanguageChange(LanguageSelected event, Emitter<LanguageState> emit) {
    selectedLanguage = event.language;
    emit(LanguageSelectSuccess(event.language));
  }
}

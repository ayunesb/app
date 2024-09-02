import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paradigm_mex/models/property.dart';

import '../../models/settings.dart';
import '../../service/settings_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final SettingsService settingsService;

  SettingsBloc()
      : super(SettingsInitialState()) {
    settingsService = SettingsService();
    on<SettingsEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(SettingsEvent event,
      Emitter<SettingsState> emit) async {
    if (event is SettingsInitialEvent) {
      try {
        List<AppSettings> settings = await settingsService.getAllSettings();
        emit(SettingsLoadSuccessState(settings));
      } catch (err) {
        emit(SettingsLoadFailureState(err.toString()));
      }
    }
    else if (event is SettingsUpdateEvent) {
      try {
        bool success = await settingsService.updateSettings(event.settings);
        if(success) {
          List<AppSettings> settings = await settingsService.getAllSettings();
          emit(SettingsLoadSuccessState(settings));
        }
      } catch (err) {
        emit(SettingsLoadFailureState(err.toString()));
      }
    }
  }
}
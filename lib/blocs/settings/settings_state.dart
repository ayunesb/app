part of 'settings_bloc.dart';


abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsLoadSuccessState extends SettingsState {
  late List<AppSettings> allSettings;
  SettingsLoadSuccessState(this.allSettings) {}
}

class SettingsLoadFailureState extends SettingsState {
  late String error;
  SettingsLoadFailureState(this.error){}
}


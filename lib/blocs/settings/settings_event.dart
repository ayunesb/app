part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class SettingsInitialEvent extends SettingsEvent {
  SettingsInitialEvent();
}

class SettingsLoadedEvent extends SettingsEvent {
  final List<AppSettings> allSettings;
  SettingsLoadedEvent({required this.allSettings});
}
class SettingsUpdateEvent extends SettingsEvent {
  final List<AppSettings> settings;
  SettingsUpdateEvent({required this.settings});
}
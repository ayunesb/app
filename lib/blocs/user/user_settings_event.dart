part of 'user_settings_bloc.dart';

@immutable
abstract class UserEvent {}

class UserInitialEvent extends UserEvent {
  UserInitialEvent();
}

class UserUpdateEvent extends UserEvent {
  User user;
  UserUpdateEvent(this.user);
}
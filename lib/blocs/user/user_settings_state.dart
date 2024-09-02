part of 'user_settings_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoadedSuccess extends UserState {
  final User user;
  UserLoadedSuccess(this.user);
}
class UserUpdatedSuccess extends UserState {
  final User user;
  UserUpdatedSuccess(this.user);
}

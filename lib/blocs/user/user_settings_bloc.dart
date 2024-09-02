import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../models/user.dart';
import '../../service/general_services.dart';

part 'user_settings_event.dart';
part 'user_settings_state.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(UserEvent event, Emitter<UserState> emit) async {
    if (event is UserInitialEvent) {
      User user = GeneralServices.getUser();
      emit(UserLoadedSuccess(user));
    }
    if (event is UserUpdateEvent) {
      User user = event.user;

      bool success = await GeneralServices.setUser(user);
      emit(UserUpdatedSuccess(user));
    }
  }
}

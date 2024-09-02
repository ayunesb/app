

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

enum TypeView { MAP, CARD_LIST }

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<FavoritesEvent>(_setView);
  }

  void _setView(FavoritesEvent event, Emitter<FavoritesState> emit) {
    if (event is TypeViewSelectedEvent) {
      emit(TypeViewSelectedSuccess(event.typeView));
    }
    else if (event is FavoriteToggleEvent) {
      emit(FavoriteToggledSuccess(event.propertyId, event.favorite));
    }
  }
}

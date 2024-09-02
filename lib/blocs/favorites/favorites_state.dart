part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class TypeViewSelectedSuccess extends FavoritesState {
  final TypeView typeView;
  TypeViewSelectedSuccess(this.typeView);
}


class FavoriteToggledSuccess extends FavoritesState {
  final String propertyId;
  final bool favorite;

  FavoriteToggledSuccess(this.propertyId, this.favorite);

  @override
  List<Object> get props => [propertyId];
}
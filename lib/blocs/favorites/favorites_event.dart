part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesEvent {}

class TypeViewSelectedEvent extends FavoritesEvent {
  final  TypeView typeView;

  TypeViewSelectedEvent({this.typeView = TypeView.CARD_LIST});
}
class FavoriteToggleEvent extends FavoritesEvent {
  final String propertyId;
  final bool favorite;

  FavoriteToggleEvent({this.propertyId = '', this.favorite = false});
}

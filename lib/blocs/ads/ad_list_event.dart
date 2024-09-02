part of 'ad_list_bloc.dart';

@immutable
abstract class AdListEvent {}

class AdListInitialEvent extends AdListEvent {
  final bool active;
  AdListInitialEvent({this.active = true});
}

class AdListLoadedEvent extends AdListEvent {
  final AdList adList;
  AdListLoadedEvent({required this.adList});
}


class AdListFilteredLoadEvent extends AdListEvent {
  final bool active;
  final AdType type;
  AdListFilteredLoadEvent({this.active = true, this.type = AdType.property});
}
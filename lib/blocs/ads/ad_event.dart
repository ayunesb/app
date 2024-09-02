part of 'ad_bloc.dart';

@immutable
abstract class AdEvent {}

class AdInitialEvent extends AdEvent {
  AdInitialEvent();
}

class AdNewEvent extends AdEvent {
  AdNewEvent();
}

class AdLoadedEvent extends AdEvent {
  final Ad ad;
  AdLoadedEvent({required this.ad});
}

class AdLoadingEvent extends AdEvent {
  final String adId;
  final bool add;
  AdLoadingEvent({required this.adId, this.add = false});
}

class AdUpdateEvent extends AdEvent {
  final Ad ad;
  AdUpdateEvent({required this.ad});
}

class AdAddEvent extends AdEvent {
  final Ad ad;
  bool createNew = false;
  bool createDuplicate = false;
  AdAddEvent({required this.ad, required createNew, required bool createDuplicate});
}

class AdDeleteEvent extends AdEvent {
  final Ad ad;
  AdDeleteEvent({required this.ad});
}
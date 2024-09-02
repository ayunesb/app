part of 'ad_bloc.dart';

abstract class AdState {}

class AdInitialState extends AdState {}

class AdLoadSuccessState extends AdState {
  late Ad? ad;
  AdLoadSuccessState(this.ad) {}
}

class AdNewState extends AdState {
  late Ad? ad;
  AdNewState(this.ad) {}
}

class AdDeletedState extends AdState {}

class AdLoadFailureState extends AdState {
  late String? err;
  AdLoadFailureState(this.err);
}
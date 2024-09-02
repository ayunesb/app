part of 'ad_list_bloc.dart';

abstract class AdListState {}

class AdListInitialState extends AdListState {}

class AdListLoadSuccessState extends AdListState {
  late AdList adList;
  AdListLoadSuccessState(this.adList) {}
}

class AdListLoadFailureState extends AdListState {
  late String err;
  AdListLoadFailureState(this.err) {}
}

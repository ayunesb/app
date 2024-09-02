import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paradigm_mex/service/ad_service.dart';

import '../../models/ad.dart';
import '../../service/database_service.dart';

part 'ad_list_event.dart';
part 'ad_list_state.dart';

class AdListBloc extends Bloc<AdListEvent, AdListState> {
  final AdService adService;

  AdListBloc({required this.adService})
      : super(AdListInitialState()) {
    on<AdListEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(
      AdListEvent event, Emitter<AdListState> emit) async {
    if (event is AdListInitialEvent) {
      bool active = event.active;
      try {
        AdList ads =
            await adService.getAds();
        emit(AdListLoadSuccessState(ads));
      } catch (err) {
        print(err);
        emit(AdListLoadFailureState(err.toString()));
      }
    } else if (event is AdListFilteredLoadEvent) {
      bool active = event.active;
      AdType type = event.type;
      try {
        AdList ads =
        await adService.getAdsByStatus(active, type);
        emit(AdListLoadSuccessState(ads));
      } catch (err) {
        print(err);
        emit(AdListLoadFailureState(err.toString()));
      }
    } else if (event is AdListLoadedEvent) {
      emit(AdListInitialState());
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paradigm_mex/models/ad.dart';
import 'package:flutter/cupertino.dart';

import '../../service/ad_service.dart';

part 'ad_state.dart';
part 'ad_event.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  late final AdService adService;

  AdBloc()
      : super(AdInitialState()) {
    adService = AdService();
    on<AdEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(AdEvent event,
      Emitter<AdState> emit) async {
    if (event is AdInitialEvent) {
      try {
        Ad ad = await adService.getAd();
        emit(AdLoadSuccessState(ad));
      } catch (err) {
        emit(AdLoadFailureState(err.toString()));
      }
    } if (event is AdNewEvent) {
      try {
        Ad ad = Ad();
        emit(AdNewState(ad));
      } catch (err) {
        emit(AdLoadFailureState(err.toString()));
      }
    } else if (event is AdLoadingEvent) {
      try {
        Ad ad = await adService.getAdById(event.adId);
        emit(AdLoadSuccessState(ad));
      } catch (err) {
        emit(AdLoadFailureState(err.toString()));
      }
    }
    else if (event is AdUpdateEvent) {
      Ad ad = event.ad;
      try {
        bool success= await adService.updateAd(ad);
        if(success) {
          emit(AdLoadSuccessState(ad));
        }
        else {
          emit(AdLoadFailureState('Error updating ad'));
        }

      } catch (err) {
        emit(AdLoadFailureState(err.toString()));
      }
    }
    else if (event is AdAddEvent) {
      Ad ad = event.ad;
      bool createNew = event.createNew;
      bool createDuplicate = event.createDuplicate;
      try {
        String newId= await adService.addAd(ad);
        if(createNew) {
          ad = Ad();
          emit(AdNewState(ad));
        }
        else if (createDuplicate) {
          emit(AdNewState(ad));
        }
        else {
          ad.id = newId;
          emit(AdLoadSuccessState(ad));
        }
      } catch (err) {
        emit(AdLoadFailureState(err.toString()));
      }
    }

    else if (event is AdDeleteEvent) {
      Ad ad = event.ad;
      try {
        bool success= await adService.deleteAd(ad);
        if(success) {
          emit(AdDeletedState());
        }
        else {
          emit(AdLoadFailureState('Error deleting ad'));
        }

      } catch (err) {
        emit(AdLoadFailureState(err.toString()));
      }
    }
  }
}
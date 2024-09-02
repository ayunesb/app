import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/service/amenitites_service.dart';

part 'amenity_event.dart';
part 'amenity_state.dart';

class AmenitiesBloc extends Bloc<AmenitiesEvent, AmenitiesState> {
  late final AmenitiesService amenitiesService;

  AmenitiesBloc()
      : super(AmenitiesInitialState()) {
    amenitiesService = AmenitiesService();
    on<AmenitiesEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(AmenitiesEvent event,
      Emitter<AmenitiesState> emit) async {
    if (event is AmenitiesInitialEvent) {
      try {
        List<PropertyEnum> amenities = await amenitiesService.getAllAmenities();
        emit(AmenitiesLoadSuccessState(amenities));
      } catch (err) {
        emit(AmenitiesLoadFailureState());
      }
    }
  }
}
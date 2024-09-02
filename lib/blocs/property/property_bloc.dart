import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paradigm_mex/models/image.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/service/amenitites_service.dart';
import 'package:paradigm_mex/service/database_service.dart';
import 'package:paradigm_mex/service/image_storage_service.dart';
import 'package:paradigm_mex/service/property_status_service.dart';

import '../../models/property.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final DatabaseService databaseService;
  final ImageStorageService imageStorage;
  late final AmenitiesService amenitiesService;
  late final PropertyStatusService propertyStatusService;

  PropertyBloc({required this.databaseService, required this.imageStorage})
      : super(PropertyInitialState()) {
    amenitiesService = AmenitiesService();
    propertyStatusService = PropertyStatusService();
    on<PropertyEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(
      PropertyEvent event, Emitter<PropertyState> emit) async {
    if (event is PropertyLoadingEvent) {
      String propertyId = event.propertyId;
      try {

        Property property = await databaseService.getProperty(propertyId: propertyId);
        property = await _fluffenUp(property);

        emit(PropertyLoadSuccessState(property));
      } catch (err) {
        emit(PropertyLoadFailureState());
      }
    } else if (event is PropertyInitialEvent) {
      emit(PropertyInitialState());
    }
  }

  Future<Property> _fluffenUp(Property property) async {
      PropertyImageList imageList = await imageStorage.getImagesForProperty(property.id);
      property.propertyImages = imageList;

      List<PropertyEnum> amenities = await amenitiesService.filterPropertyAmenities(property.amenitiesIds!);
      property.amenities = amenities;

      try {
        PropertyEnum status = await propertyStatusService.getPropertyStatus(
            property.statusId);
        property.status = status;
      } on Error catch(err) {
        throw('Error setting status for property ${property.id}, it is \'${property.statusId}\'');
      }
    return  property;
  }
}

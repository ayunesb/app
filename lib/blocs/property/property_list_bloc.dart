import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paradigm_mex/models/image.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/service/amenitites_service.dart';
import 'package:paradigm_mex/service/database_service.dart';
import 'package:paradigm_mex/service/general_services.dart';
import 'package:paradigm_mex/service/image_storage_service.dart';
import 'package:paradigm_mex/service/property_status_service.dart';

part 'property_list_event.dart';
part 'property_list_state.dart';

class PropertyListBloc extends Bloc<PropertyListEvent, PropertyListState> {
  final DatabaseService databaseService;
  final ImageStorageService imageStorage;
  late final AmenitiesService amenitiesService;
  late final PropertyStatusService propertyStatusService;

  PropertyListBloc({required this.databaseService, required this.imageStorage})
      : super(PropertyListInitialState()) {
    amenitiesService = AmenitiesService();
    propertyStatusService = PropertyStatusService();
    on<PropertyListEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(
      PropertyListEvent event, Emitter<PropertyListState> emit) async {
    if (event is PropertyListInitialEvent) {
      ActiveType activeType = event.active;
      try {
        PropertyList properties =
            await databaseService.getProperties(active: activeType);
        properties.list = (await _fluffenUp(properties.list));
        _getFavorites(properties);
        emit(PropertyListLoadSuccessState(properties));
      } catch (err, stacktrace) {
        emit(PropertyListLoadFailureState(errorMsg: err.toString(), stacktrace: stacktrace));
      }
    } else if (event is PropertyListLoadedEvent) {
      emit(PropertyListInitialState());
    }
  }

  Future<List<Property>> _fluffenUp(List<Property> list) async {
    PropertyImageList propertyImageList = await databaseService.getAllImages();
    Map<String, PropertyImageList> propertiesAndImages =
        Map<String, PropertyImageList>();
    for (PropertyImage image in propertyImageList.list) {
      PropertyImageList? plist = propertiesAndImages[image.propertyId] != null
          ? propertiesAndImages[image.propertyId]
          : new PropertyImageList([]);
      plist?.addPropertyImage(image);
      propertiesAndImages[image.propertyId!] = plist!;
    }

    for (Property property in list) {
      try {
        List<PropertyEnum> amenities = await amenitiesService
            .filterPropertyAmenities(property.amenitiesIds!);
        property.amenities = amenities;
      } on Exception catch(err) {
        throw 'Error setting amenities for property ${property.id}: ${err}';
      }

        propertyStatusService.getPropertyStatus(property.statusId)
            .then((status) => property.status = status)
            .onError((error, stackTrace) => throw 'Error setting status for property ${property.id}: ${error}');

      if (propertiesAndImages[property.id] != null) {
        property.propertyImages = propertiesAndImages[property.id];
      }
    }
    return list;
  }

  Future<PropertyList> _getFavorites(PropertyList properties) async {
    List<String> favoritePropertyIds = GeneralServices.getFavoritePropertyIds();
    for (Property property in properties.list) {
      property.favorite = favoritePropertyIds.contains(property.id);
    }
    return properties;
  }
}

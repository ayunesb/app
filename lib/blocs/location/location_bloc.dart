import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:paradigm_mex/helpers/imageHelper.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LatLng currentLocation = LatLng(37.42796133580664, -122.085749655962);
  late bool _serviceEnabled;
  Location location = new Location();
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  late BitmapDescriptor icon;
  late BitmapDescriptor group_icon;
  late BitmapDescriptor icon_favorite;
  late BitmapDescriptor group_icon_favorite;
  late BitmapDescriptor icon_promoted;
  late BitmapDescriptor group_icon_promoted;

  LocationBloc() : super(LocationInitial()) {
    on<LocationLoad>(_startListenLocation);
    on<LocationSuccess>(_setLocation);
  }

  void _setLocation(LocationSuccess event, Emitter<LocationState> emit) {
    currentLocation = event.current_location;
    emit(CurrentLocationGranted(currentLocation));
  }

  Future<void> _startListenLocation(
      LocationLoad event, Emitter<LocationState> emit) async {
    await getIcons(event.context);

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    } else {
      _locationData = await location.getLocation();

      emit(CurrentLocationGranted(
          LatLng(_locationData.latitude ?? 0, _locationData.longitude ?? 0)));
    }
  }

  // Cargar imagen del Marker
  getIcons(BuildContext context) async {
    this.group_icon =await ImageHelper.bitmapDescriptorFromSvgAsset(
        context, "assets/svg/multi-pin.svg", 64,32);
    this.group_icon_favorite =await ImageHelper.bitmapDescriptorFromSvgAsset(
        context, "assets/svg/multi-pin_favorite.svg", 64, 32);
    this.group_icon_promoted =await ImageHelper.bitmapDescriptorFromSvgAsset(
        context, "assets/svg/multi-pin_promoted.svg", 64, 32);


    this.icon = await ImageHelper.bitmapDescriptorFromSvgAsset(
        context, "assets/svg/pin.svg", 32, 32);
    this.icon_favorite = await ImageHelper.bitmapDescriptorFromSvgAsset(
        context, "assets/svg/pin_favorite.svg", 32, 32);
    this.icon_promoted = await ImageHelper.bitmapDescriptorFromSvgAsset(
        context, "assets/svg/pin_promoted.svg", 32, 32);
  }
}

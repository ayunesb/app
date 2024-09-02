import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'marker_event.dart';
part 'marker_state.dart';

class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {
  LatLng currentMarkerPosition = LatLng(0, 0);

  MarkerBloc() : super(MarkerInitial()) {
    on<MarkerSelectedEvent>(_setMarker);
    on<PropertyCardSelectedEvent>(_setMapCameraPosition);
  }

  void _setMarker(MarkerSelectedEvent event, Emitter<MarkerState> emit) {
    currentMarkerPosition = event.property_location;
    emit(MarkerSelectedSuccess(currentMarkerPosition, event.marker_position));
  }

  void _setMapCameraPosition(
      PropertyCardSelectedEvent event, Emitter<MarkerState> emit) {
    currentMarkerPosition = event.property_location;
    emit(PropertyCardSelectedSuccess(currentMarkerPosition));
  }
}

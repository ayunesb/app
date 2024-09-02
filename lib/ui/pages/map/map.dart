import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paradigm_mex/blocs/ads/ad_list_bloc.dart';
import 'package:paradigm_mex/blocs/filters/filters_bloc.dart';
import 'package:paradigm_mex/blocs/location/location_bloc.dart';
import 'package:paradigm_mex/blocs/property/property_list_bloc.dart';
import 'package:paradigm_mex/blocs/widgets/marker_bloc.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/service/analytics_service.dart';
import 'package:paradigm_mex/ui/widgets/property/filters.dart';
import 'package:paradigm_mex/ui/widgets/property/property_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../blocs/ads/ad_bloc.dart';
import '../../../blocs/favorites/favorites_bloc.dart';
import '../../../generated/l10n.dart';
import '../../../models/ad.dart';
import '../../../service/general_services.dart';
import '../../components/PropertyDetailsCard.dart';
import '../../components/settings_selector.dart';
import '../../widgets/AdDialog.dart';

class MapSample extends StatefulWidget {
  final AnimationController animationController;

  const MapSample({Key? key, required this.animationController})
      : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with WidgetsBindingObserver {
  final Permission _permission = Permission.locationWhenInUse;
  bool _checkingPermission = false;
  AnalyticsServices analytics = AnalyticsServices();
  final Completer<GoogleMapController> _mapController = Completer();
  Future _mapFuture = Future.delayed(Duration(milliseconds: 250), () => true);
  LatLng northEast = LatLng(0, 0);
  LatLng southWest = LatLng(0, 0);
  late BitmapDescriptor myIcon;

  MapSampleState() {}

  var maptype = MapType.normal;

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_checkingPermission) {
      _checkingPermission = true;
      _checkPermission(_permission).then((_) => _checkingPermission = false);
    }
  }

  Future<void> _checkPermission(Permission permission) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted) {
      BlocProvider.of<LocationBloc>(context).add(LocationLoad(context));
    } else if (status == PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
    }
  }

  void _setBounds(Property property) {
    if (property.location != null) {
      if (northEast.latitude == 0 ||
          (property.location!.latitude > northEast.latitude &&
              property.location!.latitude != 0)) {
        northEast = LatLng(property.location!.latitude, northEast.longitude);
      }
      if (northEast.longitude == 0 ||
          (property.location!.longitude > northEast.longitude &&
              property.location!.longitude != 0)) {
        northEast = LatLng(northEast.latitude, property.location!.longitude);
      }
      if (southWest.latitude == 0 ||
          (property.location!.latitude < southWest.latitude &&
              property.location!.latitude != 0)) {
        southWest = LatLng(property.location!.latitude, southWest.longitude);
      }
      if (southWest.longitude == 0 ||
          (property.location!.longitude < southWest.longitude &&
              property.location!.longitude != 0)) {
        southWest = LatLng(southWest.latitude, property.location!.longitude);
      }
    }
  }

  BitmapDescriptor _getPropertyIcon(property, property_location, properties) {
    bool isGroup = checkLocation(property_location, properties, property);
    bool isFavorite = checkFavorite(property_location, properties, property);
    bool isPromoted = checkPromoted(property_location, properties, property);

    BitmapDescriptor pinIcon = isGroup
        ? isPromoted
            ? BlocProvider.of<LocationBloc>(context).group_icon_promoted
            : isFavorite
                ? BlocProvider.of<LocationBloc>(context).group_icon_promoted
                : BlocProvider.of<LocationBloc>(context).group_icon
        : isPromoted
            ? BlocProvider.of<LocationBloc>(context).icon_promoted
            : isFavorite
                ? BlocProvider.of<LocationBloc>(context).icon_favorite
                : BlocProvider.of<LocationBloc>(context).icon;

    return pinIcon;
  }

  Set<Marker> createMarkers(
      List<Property> properties, PropertyFilters? filters) {
    Set<Marker> markers = Set();
    for (var i = 0; i < properties.length; i++) {
      Property property = properties[i];
      if (filterProperty(property, filters)) {
        _setBounds(property);
        LatLng property_location = LatLng(property.location?.latitude ?? 0,
            property.location?.longitude ?? 0);
        markers.add(
          Marker(
              markerId: MarkerId("${i}"),
              position: property_location,
              icon: _getPropertyIcon(property, property_location, properties),
              consumeTapEvents: true,
              onTap: () {
                if (widget.animationController.isDismissed) {
                  widget.animationController.forward();
                }
                BlocProvider.of<MarkerBloc>(context).add(MarkerSelectedEvent(
                    LatLng(property.location?.latitude ?? 0,
                        property.location?.longitude ?? 0),
                    i));
              }),
        );
        LatLngBounds bound =
            LatLngBounds(southwest: southWest, northeast: northEast);
        CameraUpdate updateBounds = CameraUpdate.newLatLngBounds(bound, 75);
        _mapController.future.then((value) {
          value.animateCamera(updateBounds);
        });
      }
    }
    return markers;
  }

  void _show(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 1,
        context: ctx,
        isScrollControlled: true,
        isDismissible: true,
        builder: (ctx) => FilterDialog()).whenComplete(() {
      setState(() {});
    });
  }

  bool _isDestacadosVisible = false;

  List<Ad>? ads = [];
  @override
  void initState() {
    super.initState();

    BlocProvider.of<AdListBloc>(context)
        .add(AdListFilteredLoadEvent(active: true, type: AdType.main));
  }
bool adShowed = false;
  @override
  Widget build(BuildContext context) {
    analytics.logScreen((MapSample).toString(), "Map");
    Ad? ad;
    return BlocBuilder<AdListBloc, AdListState>(builder: (context, state) {

      if (state is AdListLoadSuccessState) {
        ads = state.adList.list;
      }
      if(!adShowed && ads!.isNotEmpty) {
        int mainAdIndex = Random().nextInt(ads!.length);
        ad = ads![mainAdIndex];
        adShowed = true;
        WidgetsBinding.instance
            .addPostFrameCallback((_) =>
            showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AdDialog(ad!);
              },
            ));
      }

      return BlocBuilder<PropertyListBloc, PropertyListState>(
        builder: (context, state) {
          if (state is PropertyListLoadSuccessState) {
            List<Property> properties = state.propertyList.list;
            return BlocBuilder<FiltersBloc, FiltersState>(
                builder: (context, state) {
              PropertyFilters? filters;
              if (state is FiltersLoadSuccessState) {
                filters = state.propertyFilters;
              } else if (state is FiltersChangedState) {
                filters = state.propertyFilters;
              }
              List<Property> promotedProperties = properties
                  .where((property) =>
              (property.promoted ?? false || property.favorite))
                  .toList();
              return BlocBuilder<LocationBloc, LocationState>(
                    builder: (context, state) {
                  Set<Marker> markers = createMarkers(properties, filters);
                  return Scaffold(
                    body: SafeArea(
                      child: Stack(
                        children: <Widget>[
                          BlocListener<MarkerBloc, MarkerState>(
                            listener: (context, state) {
                              if (state is PropertyCardSelectedSuccess) {
                                _mapController.future.then((value) {
                                  value.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                          target: state.property_location,
                                          zoom: 15),
                                    ),
                                  );
                                });
                              }
                            },
                            child: FutureBuilder(
                              future: _mapFuture,
                              builder: (context, snapshot) {

                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Text(""),
                                  );
                                }

                                double lat = southWest.latitude +
                                    ((northEast.latitude - southWest.latitude) /
                                        2);
                                double long = southWest.longitude +
                                    ((northEast.longitude -
                                            southWest.longitude) /
                                        2);
                                CameraPosition _kGooglePlex = CameraPosition(
                                  target: LatLng(lat, long),
                                  zoom: 5,
                                );

                                return GoogleMap(
                                  mapType: maptype,
                                  initialCameraPosition: _kGooglePlex,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _mapController.complete(controller);
                                    // LatLngBounds bound = LatLngBounds(
                                    //     southwest: southWest,
                                    //     northeast: northEast);
                                    // CameraUpdate updateBounds =
                                    //     CameraUpdate.newLatLngBounds(bound, 50);
                                    // controller.animateCamera(updateBounds);

                                    // if (!GeneralServices.firstTimeOnApp() &&
                                    //     ad != null) {
                                    //   showDialog<String>(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return AdDialog(ad!);
                                    //     },
                                    //   );
                                    // }
                                  },
                                  markers: markers,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: false,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 40,
                            right: 15,
                            left: 15,
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: BlocBuilder<FiltersBloc,
                                                  FiltersState>(
                                              builder: (context, state) {
                                            PropertyFilters filters =
                                                PropertyFilters();
                                            if (state
                                                is FiltersLoadSuccessState) {
                                              filters = state.propertyFilters;
                                            } else if (state
                                                is FiltersChangedState) {
                                              filters = state.propertyFilters;
                                            }

                                            if (filters != null) {
                                              return Container(
                                                  height: 42,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 4.0,
                                                          bottom: 4.0),
                                                      child: Container(
                                                          height: 40.0,
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                            initialValue: filters
                                                                    .initialized
                                                                ? filters
                                                                    .propertyName
                                                                    .values[0]
                                                                : '',
                                                            onChanged: (String
                                                                    value) =>
                                                                {
                                                              filters.propertyName
                                                                      .values[
                                                                  0] = value
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    suffixIcon:
                                                                        IconButton(
                                                                      splashColor:
                                                                          Colors
                                                                              .black,
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .search_outlined),
                                                                      onPressed:
                                                                          () {
                                                                        BlocProvider.of<FiltersBloc>(context).add(FiltersChangedEvent(
                                                                            propertyFilters:
                                                                                filters));
                                                                      },
                                                                    )),
                                                          ))));
                                            } else {
                                              return Text('');
                                            }
                                          }))),
                                  IconButton(
                                    splashColor: Colors.black,
                                    icon: const Icon(Icons.list),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PropertyListWidget(
                                                  listType:
                                                      ListType.PROPERTY_LIST,
                                                  animationController: widget
                                                      .animationController,
                                                )),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    splashColor: Colors.black,
                                    icon: const Icon(Icons.filter_alt_outlined),
                                    onPressed: () {
                                      _show(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 100,
                              right: 8,
                              child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                child: const Icon(Icons.gps_fixed),
                                onPressed: () {
                                  _mapController.future.then((value) {
                                    value.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target:
                                                BlocProvider.of<LocationBloc>(
                                                        context)
                                                    .currentLocation,
                                            zoom: 14),
                                      ),
                                    );
                                  });
                                },
                              )),
                          Positioned(
                              top: 165,
                              right: 8,
                              child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                child: const Icon(Icons.layers_outlined),
                                onPressed: () {
                                  setState(() {
                                    this.maptype = maptype == MapType.normal
                                        ? MapType.satellite
                                        : MapType.normal;
                                  });
                                },
                              )),
                          if (promotedProperties.isNotEmpty)
                            Positioned(
                                top: 240,
                                right: 0,
                                child: Visibility(
                                    visible: !_isDestacadosVisible,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(0),
                                        fixedSize: Size(48, 48),
                                        maximumSize: Size(48, 48),
                                        minimumSize: Size(48, 48),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5.0),
                                              bottomLeft: Radius.circular(5.0)),
                                        ),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.all(0),
                                          child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Icon(
                                                Icons.chevron_left_sharp,
                                                color: Colors.black,
                                                size: 50,
                                              ))),
                                      onPressed: () {
                                        setState(() {
                                          _isDestacadosVisible =
                                              !_isDestacadosVisible;
                                        });
                                      },
                                    ))),
                          if (promotedProperties.isNotEmpty)
                            Positioned(
                                top: 240,
                                right: 0,
                                child: Visibility(
                                  visible: _isDestacadosVisible,
                                  child: Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(0),
                                                fixedSize: Size(48, 48),
                                                maximumSize: Size(48, 48),
                                                minimumSize: Size(48, 48),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5.0)),
                                                ),
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsets.all(0),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Icon(
                                                        Icons
                                                            .chevron_right_sharp,
                                                        color: Colors.black,
                                                        size: 50,
                                                      ))),
                                              onPressed: () {
                                                setState(() {
                                                  _isDestacadosVisible =
                                                      !_isDestacadosVisible;
                                                });
                                              },
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5.0))),
                                              padding: EdgeInsets.all(0),
                                              margin: EdgeInsets.all(0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              constraints: BoxConstraints(
                                                  maxHeight: 275),
                                              child: Column(children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        S
                                                            .of(context)
                                                            .promoted_title,
                                                        style: TextStyle(
                                                            fontSize: 16))),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    constraints: BoxConstraints(
                                                        maxHeight: 250),
                                                    child: ListView(
                                                      padding: EdgeInsets.zero,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      children: promotedProperties
                                                          .map((property) => Container(
                                                              height: 88,
                                                              child: PropertyDetailsCard(
                                                                  property:
                                                                      property,
                                                                  size: CardSize
                                                                      .small)))
                                                          .toList(),
                                                    ))
                                              ]),
                                            )
                                          ])),
                                ))
                        ],
                      ),
                    ),
                  );
                });
            });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    });
  }

  showLanguageSelector() async {
    if (GeneralServices.firstTimeOnApp()) {
      //choose language
      await showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AppLanguageSelector());
        },
      );
    }
  }

  bool checkLocation(
      LatLng property_location, List<Property> properties, Property property) {
    int counter = 0;
    properties.forEach((element) {
      if (element.location?.longitude == property_location.longitude &&
          element.location?.latitude == property_location.latitude) {
        counter++;
      }
    });
    return counter > 1;
  }

  bool checkFavorite(
      LatLng property_location, List<Property> properties, Property property) {
    bool favorite = false;

    // for a group all have to be made favorites
    properties.forEach((element) {
      if (element.location?.longitude == property_location.longitude &&
          element.location?.latitude == property_location.latitude) {
        favorite |= element.favorite;
      }
    });

    return favorite;
  }

  bool checkPromoted(
      LatLng property_location, List<Property> properties, Property property) {
    bool promoted = false;

    // for a group all have to be made favorites
    properties.forEach((element) {
      if (element.location?.longitude == property_location.longitude &&
          element.location?.latitude == property_location.latitude) {
        promoted |= element.promoted ?? false;
      }
    });

    return promoted;
  }
}

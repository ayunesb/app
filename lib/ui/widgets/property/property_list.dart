import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paradigm_mex/blocs/filters/filters_bloc.dart';
import 'package:paradigm_mex/blocs/property/property_list_bloc.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:paradigm_mex/models/image.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/service/general_services.dart';
import 'package:paradigm_mex/ui/widgets/property/property_common.dart';
import 'package:paradigm_mex/ui/widgets/property/property_detail.dart';

import '../../../blocs/ads/ad_bloc.dart';
import '../../../blocs/favorites/favorites_bloc.dart';
import '../../../blocs/location/location_bloc.dart';
import '../../../blocs/widgets/marker_bloc.dart';
import '../../../models/ad.dart';
import '../AdDialog.dart';
import 'filters.dart';

enum ListType { FAVORITES, PROPERTY_LIST }

///Widget for property list view
///
/// Shows properties in a list containing cards
class PropertyListWidget extends StatefulWidget {
  final ListType listType;
  final AnimationController animationController;

  const PropertyListWidget(
      {this.listType = ListType.PROPERTY_LIST,
      required this.animationController})
      : super();

  @override
  _PropertyListWidgetState createState() =>
      _PropertyListWidgetState(listType: this.listType);
}

class _PropertyListWidgetState extends State<PropertyListWidget> {
  late bool ascending = true;
  final ListType listType;
  final Completer<GoogleMapController> _mapController = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.211276699942857, -87.46590045292253),
    zoom: 12,
  );

  _PropertyListWidgetState({this.listType = ListType.PROPERTY_LIST});

  var maptype = MapType.normal;

  List<Property> properties = [];

  @override
  void initState() {
    super.initState();
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

  void onFavoriteChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is TypeViewSelectedSuccess) {
          return state.typeView == TypeView.CARD_LIST
              ? Scaffold(
                  backgroundColor: Color.fromRGBO(233, 228, 228, 1.0),
                  body: SafeArea(
                    child: BlocBuilder<PropertyListBloc, PropertyListState>(
                        builder: (context, state) {
                      if (state is PropertyListLoadSuccessState) {
                        List<Property> properties = state.propertyList
                            .sortByCurrentPrice(this.ascending)
                            .list;
                        List<Widget> rows = [];

                        String title = '';
                        switch (listType) {
                          case ListType.PROPERTY_LIST:
                            {
                              title = S.of(context).explore;
                              break;
                            }
                          case ListType.FAVORITES:
                            {
                              title = S.of(context).favorite;
                              break;
                            }
                          default:
                            {
                              title = '${listType} title not implemented';
                            }
                        }

                        rows.add(
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, left: 4.0),
                              child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                16, 16, 8, 16),
                                            child: Text(
                                              title,
                                              textAlign: TextAlign.left,
                                              style: ThemeData.light()
                                                  .textTheme
                                                  .headline1
                                                  ?.copyWith(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )),
                                      ),
                                      BlocBuilder<AdBloc, AdState>(
                                          builder: (context, state) {
                                        Ad? ad;
                                        if (state is AdLoadSuccessState) {
                                          print(
                                              '++++++++++++++++++++++++++++++ ADDDDDD');
                                          ad = state.ad;
                                        }

                                        return BlocProvider(
                                          create: (context) => LocationBloc(),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: IconButton(
                                              splashColor: Colors.black,
                                              icon: const Icon(
                                                  Icons.map_outlined),
                                              onPressed: () {
                                                if (ad != null) {
                                                  Future.delayed(Duration.zero,
                                                      () {
                                                    showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AdDialog(ad!);
                                                      },
                                                    );
                                                  });
                                                } else {
                                                  print(
                                                      '+++++++++++++ IS NULLLLLLLL');
                                                }
                                                if (listType ==
                                                    ListType.FAVORITES) {
                                                  BlocProvider.of<
                                                              FavoritesBloc>(
                                                          context)
                                                      .add(
                                                          TypeViewSelectedEvent(
                                                              typeView: TypeView
                                                                  .MAP));
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                      if (listType != ListType.FAVORITES)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: IconButton(
                                            splashColor: Colors.black,
                                            icon: const Icon(
                                                Icons.filter_alt_outlined),
                                            onPressed: () {
                                              _show(context);
                                            },
                                          ),
                                        ),
                                    ],
                                  ))),
                        );
                        rows.add(Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 3),
                                child: SizedBox(
                                  height: 24,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        this.ascending = !this.ascending;
                                      });
                                    },
                                    icon: Text(
                                      S.of(context).price,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    label: Icon(
                                      this.ascending
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color: Colors.black,
                                      size: 16.0,
                                      semanticLabel: 'Sort',
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(255, 255, 255, 0.5),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ))));

                        return BlocBuilder<FiltersBloc, FiltersState>(
                            builder: (context, state) {
                          PropertyFilters? filters;
                          if (listType != ListType.FAVORITES) {
                            if (state is FiltersLoadSuccessState) {
                              filters = state.propertyFilters;
                            } else if (state is FiltersChangedState) {
                              filters = state.propertyFilters;
                            }
                          }
                          List<PropertyCard> propertyCards = [];
                          for (Property p in properties) {
                            if ((listType == ListType.PROPERTY_LIST &&
                                    filterProperty(p, filters)) ||
                                ((listType == ListType.FAVORITES &&
                                    p.favorite))) {
                              propertyCards.add(PropertyCard(
                                  property: p, onChange: onFavoriteChange));
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ...rows,
                              Flexible(
                                  fit: FlexFit.tight,
                                  child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        children: propertyCards.isNotEmpty
                                            ? propertyCards
                                            : [
                                                Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text(
                                                        S
                                                            .of(context)
                                                            .no_matching_results,
                                                        style: TextStyle(
                                                            fontSize: 16))),
                                              ],
                                      )))
                            ],
                          );
                        });
                      } else if (state is PropertyListLoadFailureState) {
                        return FailurePropertyList(
                            errorMsg: state.errorMsg,
                            stacktrace: state.stacktrace);
                      } else {
                        return LoadingPropertyList();
                      }
                    }),
                  ),
                )
              : FavoritesMap();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget FavoritesMap() {
    return BlocBuilder<PropertyListBloc, PropertyListState>(
      builder: (context, state) {
        if (state is PropertyListLoadSuccessState) {
          List<Property> properties =
              state.propertyList.sortByCurrentPrice(this.ascending).list;
          Set<Marker> markers = createMarkers(
              BlocProvider.of<LocationBloc>(context).icon, properties);
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
                                  target: state.property_location, zoom: 15),
                            ),
                          );
                        });
                      }
                    },
                    child: GoogleMap(
                      mapType: maptype,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController.complete(controller);
                      },
                      markers: markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 15,
                    left: 15,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              S.of(context).favorite,
                              textAlign: TextAlign.left,
                              style: ThemeData.light()
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            ),
                          )),
                          IconButton(
                            splashColor: Colors.black,
                            icon: const Icon(Icons.list),
                            onPressed: () {
                              BlocProvider.of<FavoritesBloc>(context).add(
                                  TypeViewSelectedEvent(
                                      typeView: TypeView.CARD_LIST));
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
                                        BlocProvider.of<LocationBloc>(context)
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
                ],
              ),
            ),
          );
        } else if (state is PropertyListLoadFailureState) {
          return FailurePropertyList(errorMsg: state.errorMsg);
        } else {
          return FailurePropertyList(
              errorMsg: 'Error loading properties for favorite map');
        }
      },
    );
  }

  Set<Marker> createMarkers(BitmapDescriptor icon, List<Property> properties) {
    Set<Marker> markers = Set();

    for (var i = 0; i < properties.length; i++) {
      Property property = properties[i];
      if (property.favorite) {
        LatLng property_location = LatLng(property.location?.latitude ?? 0,
            property.location?.longitude ?? 0);
        markers.add(
          Marker(
              markerId: MarkerId("${i}"),
              position: property_location,
              icon: icon,
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
      }
    }
    return markers;
  }
}

///
class PropertyCard extends StatelessWidget {
  static const width = 340.0;
  final Property property;
  final Function() onChange;

  PropertyCard({required this.property, required this.onChange}) : super();

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PropertyDetail(property, onChange)),
          );
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImageRow(images: property.propertyImages),
              PriceRow(property: this.property, onChange: this.onChange),
              AddressRow(property: property),
              AmenitiesRow(property: property),
            ],
          ),
        ));
  }
}

class ImageRow extends StatelessWidget {
  static const imageHeight = 84.0;
  static const imageWidth = 84.0;
  static const padding = 4.0;
  late final PropertyImageList images;

  ImageRow({PropertyImageList? images}) : super() {
    this.images = images ?? PropertyImageList([]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - (2 * padding);
    double imageDimension = width / 3 - 2 * padding;

    List<Widget> _imageWidgets = [];
    for (int i = 0; i < 3; i++) {
      if (images.list.length > i) {
        PropertyImage propertyImage = images.list[i];
        _imageWidgets.add(Padding(
            padding: const EdgeInsets.fromLTRB(
                padding, padding, padding, 2 * padding),
            child: Image.network(
              propertyImage.url!,
              fit: BoxFit.cover,
              height: imageDimension,
              width: imageDimension,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                    width: imageDimension,
                    height: imageDimension,
                    child: Container(
                        width: imageDimension,
                        child: Stack(children: [
                          Image.asset('assets/images/defaultProperty.png',
                              fit: BoxFit.cover,
                              height: imageDimension,
                              width: imageDimension),
                          Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        ])));
              },
            )));
      } else {
        // pad with default Image
        _imageWidgets.add(Padding(
            padding: const EdgeInsets.fromLTRB(
                padding, padding, padding, 2 * padding),
            child: Image.asset('assets/images/defaultProperty.png',
                fit: BoxFit.cover,
                height: imageDimension,
                width: imageDimension)));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _imageWidgets,
    );
  }
}

class PriceRow extends StatelessWidget {
  static const padding = 4.0;
  final Property property;
  final Function() onChange;

  const PriceRow({required this.property, required this.onChange}) : super();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(padding, 0, 8 * padding, 0),
            child: Text(
              GeneralServices.getCurrencyStr(this.property.currentPrice,
                      this.property.currentPriceUSD) +
                  (this.property.regularPrice > 0.0
                      ? ('   (' +
                          GeneralServices.getCurrencyStr(
                              this.property.regularPrice,
                              this.property.regularPriceUSD) +
                          ')')
                      : ''),
              style: TextStyle(fontSize: 16),
            )),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, padding, 0),
          child: FavoriteButton(property, onChange),
        ),
      ],
    );
  }
}

class AddressRow extends StatelessWidget {
  static const width = 340.0;
  static const padding = 4.0;
  final Property property;

  const AddressRow({required this.property}) : super();

  @override
  Widget build(BuildContext context) {
    String streetAddress = '';
    streetAddress += this.property.houseNumber.isNotEmpty
        ? (this.property.houseNumber + ' ')
        : '';
    streetAddress += this.property.streetAddress.isNotEmpty
        ? (this.property.streetAddress + ', ')
        : '';
    streetAddress +=
        this.property.village.isNotEmpty ? (this.property.village + ', ') : '';
    streetAddress +=
        this.property.colonia.isNotEmpty ? (this.property.colonia + ', ') : '';
    streetAddress += this.property.province.isNotEmpty
        ? (this.property.province + ', ')
        : '';
    streetAddress += this.property.country;
    return Padding(
        padding: const EdgeInsets.fromLTRB(padding, 0, 0, padding),
        child: Column(children: [
          if (this.property.propertyName.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  this.property.propertyName,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(streetAddress,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Inter',
                    )),
              ),
            ],
          ),
        ]));
  }
}

class AmenitiesRow extends StatelessWidget {
  static const width = 340.0;
  static const padding = 4.0;
  final Property property;

  const AmenitiesRow({required this.property}) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(padding, 0, 0, 20),
        child: IntrinsicHeight(
          child: Row(children: <Widget>[
            RichText(
              text: TextSpan(
                children: <InlineSpan>[
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.bed,
                        size: 12,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Inter',
                    ),
                    text: " " +
                        this.property.bedrooms.toString() +
                        ' ' +
                        S.of(context).bed,
                  ),
                ],
              ),
            ),
            VerticalDivider(
              thickness: 1,
              width: 10,
              color: Color.fromRGBO(219, 219, 219, 1.0),
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.shower,
                        size: 12,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Inter',
                    ),
                    text: this.property.bathrooms.toString() +
                        ' ' +
                        S.of(context).bath,
                  ),
                ],
              ),
            ),
            VerticalDivider(
              thickness: 1,
              width: 10,
              color: Color.fromRGBO(219, 219, 219, 1.0),
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.aspect_ratio,
                        size: 12,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Inter',
                    ),
                    text: GeneralServices.getSquareFootage(property.meters),
                  ),
                ],
              ),
            ),
            if (property.yearBuilt > 0)
              VerticalDivider(
                thickness: 1,
                width: 10,
                color: Color.fromRGBO(219, 219, 219, 1.0),
              ),
            if (property.yearBuilt > 0)
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary,
                    fontFamily: 'Inter',
                  ),
                  text: property.yearBuilt.toString(),
                ),
              ),
            VerticalDivider(
              thickness: 1,
              width: 10,
              color: Color.fromRGBO(219, 219, 219, 1.0),
            ),
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(3),
              color: Color.fromRGBO(248, 248, 248, 1.0),
              child: RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      // TODO change color based on status?
                      child: Icon(Icons.circle,
                          size: 6, color: Color.fromRGBO(255, 198, 50, 1.0)),
                    ),
                    TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(80, 80, 80, 1.0),
                          fontFamily: 'Inter',
                        ),
                        text: " " +
                            ((GeneralServices.getLocale() == "en"
                                    ? this.property.status?.enLabel
                                    : this.property.status?.esLabel) ??
                                "")),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}

///
class LoadingPropertyList extends StatelessWidget {
  const LoadingPropertyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingIndicator(
        key: UniqueKey(),
      ),
    );
  }
}

class FailurePropertyList extends StatelessWidget {
  final String errorMsg;
  late StackTrace? stacktrace;

  FailurePropertyList(
      {Key? key, required this.errorMsg, this.stacktrace = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('${this.errorMsg}\n ${stacktrace.toString()}'),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    );
  }
}
